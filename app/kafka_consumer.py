##########################################################
# kafka_consumer.py
#
# This module runs a background Kafka consumer that listens to CDC topics
# and stores incoming messages in a thread-safe queue. It converts raw Kafka
# messages into CDCEvent objects and returns them when requested.
# After processing, it manually commits offsets. The consumer restarts
# automatically if any error occurs.
##########################################################

import threading
import json
import time
from collections import defaultdict
from confluent_kafka import Consumer, KafkaError, KafkaException, TopicPartition
from app.logging_config import AppLogger
from .models import CDCEvent

log = AppLogger(component="kafka_consumer")

TOPICS = ["cdc.public.legacy_orders", "cdc.public.legacy_customers"]
BOOTSTRAP = "kafka:9092"
GROUP_ID = "time-window-consumer"

# message queue for FastAPI
message_queue = []
queue_lock = threading.Lock()

def create_consumer() -> Consumer:
    """
    Create and configure a Kafka consumer instance
    """
    log.info("Creating new Kafka consumer...")
    return Consumer({
        "bootstrap.servers": BOOTSTRAP,
        "group.id": GROUP_ID,
        "enable.auto.commit": False,
        "auto.offset.reset": "earliest",
        "session.timeout.ms": 10000,
        "heartbeat.interval.ms": 3000
    })


def build_cdc_event(m: dict) -> CDCEvent:
    """
    Build a structured CDCEvent object from raw Kafka payload
    """
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

def consume_loop():
    """
    Kafka consumer loop: polls messages, handles errors, queues valid events,
    and restarts automatically on failure
    """
    while True:
        consumer = None

        try:
            consumer = create_consumer()
            consumer.subscribe(TOPICS)
            log.info("Subscribed to topics", topics=TOPICS)

            while True:
                msg = consumer.poll(1.0)

                if msg is None:
                    continue

                if msg.error():
                    if msg.error().code() == KafkaError._PARTITION_EOF:
                        continue

                    log.error(
                        "Kafka error received",
                        error=str(msg.error()),
                        topic=msg.topic(),
                        partition=msg.partition(),
                    )
                    continue

                try:
                    payload = json.loads(msg.value().decode("utf-8"))
                except UnicodeDecodeError as e:
                    log.exception(
                        "Failed to parse Kafka message as JSON",
                        error=str(e),
                        topic=msg.topic(),
                        partition=msg.partition(),
                        offset=msg.offset(),
                    )
                    continue

                with queue_lock:
                    message_queue.append({
                        "key": msg.key(),
                        "data": payload,
                        "topic": msg.topic(),
                        "partition": msg.partition(),
                        "offset": msg.offset()
                    })

        except KafkaException as e:
            log.exception(
                "Kafka consumer crashed with KafkaException",
                error=str(e),
            )

        except Exception as e:
            log.exception(
                "Consumer crashed with unexpected error",
                error=str(e),
            )

        finally:
            if consumer:
                try:
                    consumer.close()
                except KafkaException as e:
                    log.error(
                        "Error while closing Kafka consumer",
                        error=str(e),
                    )

            time.sleep(3)


def start_consumer_loop():
    """
    Start the consumer loop in a background
    """
    log.info("Starting Kafka consumer thread...")
    t = threading.Thread(target=consume_loop, daemon=True)
    t.start()


def get_messages() -> list[CDCEvent]:
    """
    Retrieve queued CDC events, convert to CDCEvent objects,
    commit offsets for processed messages, and return event list.
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
        consumer = create_consumer()
        tps = [
            TopicPartition(topic, partition, offset + 1)
            for (topic, partition), offset in offsets.items()
        ]
        try:
            consumer.commit(offsets=tps)
            log.info(
                "Committed offsets",
                offsets=[str(tp) for tp in tps],
            )
        except KafkaException as e:
            log.exception(
                "Error committing offsets",
                error=str(e),
                offsets=[str(tp) for tp in tps],
            )
        finally:
            try:
                consumer.close()
            except KafkaException as e:
                log.error(
                    "Error closing consumer after commit",
                    error=str(e),
                )

    return results