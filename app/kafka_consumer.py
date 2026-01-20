import threading
import json
import time
from collections import defaultdict
from confluent_kafka import Consumer, KafkaError, TopicPartition
import logging
from .models import CDCEvent

logger = logging.getLogger("app.consumer")

TOPICS = ["cdc.public.legacy_orders", "cdc.public.legacy_customers"]
BOOTSTRAP = "kafka:9092"
GROUP_ID = "time-window-consumer"

# message queue for FastAPI
message_queue = []
queue_lock = threading.Lock()


# ---------------------- Helper to build consumer ----------------------

def create_consumer() -> Consumer:
    """
    Create new Kafka consumer instance.
    """
    logger.info("Creating new Kafka consumer...")
    return Consumer({
        "bootstrap.servers": BOOTSTRAP,
        "group.id": GROUP_ID,
        "enable.auto.commit": False,
        "auto.offset.reset": "earliest",
        "session.timeout.ms": 10000,
        "heartbeat.interval.ms": 3000
    })


# ---------------------- CDCEvent builder ----------------------

def build_cdc_event(m: dict) -> CDCEvent:
    k = m.get("key")
    if k is not None:
        k = json.loads(k.decode("utf-8"))

    value = m["data"]
    schema = value.get("schema") or {}
    payload = value.get("payload") or {}

    return CDCEvent(
        key=k,
        schema=schema,
        payload=payload,
    )


# ---------------------- Main background loop ----------------------

def consume_loop():
    """
    Continuously reads Kafka messages and automatically
    recovers from broker restarts, disconnects and errors.
    """
    while True:
        consumer = None

        try:
            consumer = create_consumer()
            consumer.subscribe(TOPICS)
            logger.info(f"Subscribed to topics: {TOPICS}")

            while True:
                msg = consumer.poll(1.0)

                if msg is None:
                    continue

                if msg.error():
                    # ignore end-of-partition indicator
                    if msg.error().code() == KafkaError._PARTITION_EOF:
                        continue

                    logger.error(f"KAFKA ERROR: {msg.error()}")
                    continue

                # decode payload
                try:
                    payload = json.loads(msg.value().decode("utf-8"))
                except Exception:
                    logger.exception("Failed to decode Kafka message")
                    continue

                with queue_lock:
                    message_queue.append({
                        "key": msg.key(),
                        "data": payload,
                        "topic": msg.topic(),
                        "partition": msg.partition(),
                        "offset": msg.offset()
                    })

        except Exception:
            logger.exception("Consumer crashed — restarting in 5s")

        finally:
            if consumer:
                try:
                    consumer.close()
                except Exception:
                    pass

            time.sleep(5)  # retry delay, helps on broker restart


# ---------------------- Starting background consumer ----------------------

def start_consumer_loop():
    logger.info("Starting Kafka consumer thread...")
    t = threading.Thread(target=consume_loop, daemon=True)
    t.start()


# ---------------------- API helper for reading messages ----------------------

def get_messages() -> list[CDCEvent]:
    """
    Reads all accumulated messages and commits offsets.
    Called from FastAPI endpoint.
    """
    with queue_lock:
        if not message_queue:
            return []

        batch = message_queue.copy()
        message_queue.clear()

    results: list[CDCEvent] = []
    offsets = defaultdict(lambda: -1)

    for msg in batch:
        event = build_cdc_event(msg)
        results.append(event)

        key = (msg["topic"], msg["partition"])
        if msg["offset"] > offsets[key]:
            offsets[key] = msg["offset"]

    # commit
    if offsets:
        consumer = create_consumer()  # for committing when previous consumer has been recreated
        tps = [
            TopicPartition(topic, partition, offset + 1)
            for (topic, partition), offset in offsets.items()
        ]
        try:
            consumer.commit(offsets=tps)
            logger.info(f"Committed offsets: {tps}")
        except Exception:
            logger.exception("Error committing offsets")
        finally:
            consumer.close()

    return results