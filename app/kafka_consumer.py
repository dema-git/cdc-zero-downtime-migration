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
from confluent_kafka import Consumer, KafkaError, KafkaException
from app.logging_config import AppLogger
from .models import CDCEvent
import os

log = AppLogger(component="kafka_consumer")

TOPICS = [os.getenv("TOPICS_LEGACY_ORDERS"), os.getenv("TOPICS_LEGACY_CUSTOMERS")]
BOOTSTRAP = os.getenv("KAFKA_BROKERCONNECT")
GROUP_ID = os.getenv("GROUP_ID")

# message queue for FastAPI
message_queue = []
queue_lock = threading.Lock()


def create_consumer() -> Consumer:
    """
    Create and configure a Kafka consumer instance
    """
    return Consumer({
        "bootstrap.servers": BOOTSTRAP,
        "group.id": GROUP_ID,
        "enable.auto.commit": False,
        "auto.offset.reset": "earliest",
        "session.timeout.ms": 10000,
        "heartbeat.interval.ms": 3000,
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
    and restarts automatically on failure.
    Also periodically commits offsets in the same thread.
    """
    COMMIT_EVERY_MESSAGES = 50
    COMMIT_EVERY_SECONDS = 5.0

    while True:
        consumer = None

        try:
            log.info("Creating new Kafka consumer...")
            consumer = create_consumer()
            consumer.subscribe(TOPICS)
            log.info("Subscribed to topics", topics=TOPICS)

            messages_since_commit = 0
            last_commit_time = time.time()

            while True:
                msg = consumer.poll(1.0)

                if msg is None:
                    _maybe_commit(consumer, messages_since_commit, last_commit_time,
                                  COMMIT_EVERY_MESSAGES, COMMIT_EVERY_SECONDS)
                    continue

                if msg.error():
                    if msg.error().code() == KafkaError._PARTITION_EOF:
                        _maybe_commit(consumer, messages_since_commit, last_commit_time,
                                      COMMIT_EVERY_MESSAGES, COMMIT_EVERY_SECONDS)
                        continue

                    log.error(
                        "Kafka error received",
                        error=str(msg.error()),
                        topic=msg.topic(),
                        partition=msg.partition(),
                    )
                    _maybe_commit(consumer, messages_since_commit, last_commit_time,
                                  COMMIT_EVERY_MESSAGES, COMMIT_EVERY_SECONDS)
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
                    _maybe_commit(consumer, messages_since_commit, last_commit_time,
                                  COMMIT_EVERY_MESSAGES, COMMIT_EVERY_SECONDS)
                    continue

                # Add message to kafka queue
                with queue_lock:
                    message_queue.append({
                        "key": msg.key(),
                        "data": payload,
                        "topic": msg.topic(),
                        "partition": msg.partition(),
                        "offset": msg.offset(),
                    })
                log.info(
                    "Enqueued CDC message from legacy topic",
                    source_topic=msg.topic(),
                    partition=msg.partition(),
                    offset=msg.offset(),
                    pipeline_stage="cdc_consume",
                )

                messages_since_commit += 1
                messages_since_commit, last_commit_time = _maybe_commit(
                    consumer,
                    messages_since_commit,
                    last_commit_time,
                    COMMIT_EVERY_MESSAGES,
                    COMMIT_EVERY_SECONDS,
                )

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


def _maybe_commit(consumer, messages_since_commit, last_commit_time,
                  commit_every_messages, commit_every_seconds):
    now = time.time()
    should_commit_by_count = messages_since_commit >= commit_every_messages
    should_commit_by_time = (now - last_commit_time) >= commit_every_seconds

    if not (should_commit_by_count or should_commit_by_time):
        return messages_since_commit, last_commit_time

    try:
        consumer.commit()
        log.info(
            "Committed CDC offsets (auto in consume_loop)",
            messages_since_commit=messages_since_commit,
            topics=TOPICS,
            pipeline_stage="cdc_consume_commit",
        )
    except KafkaException as e:
        log.exception(
            "Error committing offsets in consume_loop",
            error=str(e),
        )

    return 0, now


def start_consumer_loop():
    """
    Start the consumer loop in a background
    """
    log.info("Starting Kafka consumer thread...")
    t = threading.Thread(target=consume_loop, daemon=True)
    t.start()


def get_messages() -> list[CDCEvent]:
    """
    Retrieve queued CDC events and convert to CDCEvent objects.
    Offsets are committed by the consumer thread.
    """
    with queue_lock:
        if not message_queue:
            return []

        batch = message_queue.copy()
        message_queue.clear()

    results: list[CDCEvent] = []

    for msg in batch:
        event = build_cdc_event(msg)
        results.append(event)

    return results