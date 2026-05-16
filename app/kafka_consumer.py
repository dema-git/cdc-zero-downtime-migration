##########################################################
# kafka_consumer.py
#
# This module runs a background Kafka consumer that listens to CDC topics,
# transforms messages into CDCEvent objects, and commits offsets only after
# the transformation pipeline completes successfully.
##########################################################

import threading
import json
import time
from collections.abc import Callable
from confluent_kafka import Consumer, KafkaError, KafkaException
from app.logging_config import AppLogger
from .models import CDCEvent
import os

log = AppLogger(component="kafka_consumer")

TOPICS = [os.getenv("TOPICS_LEGACY_ORDERS"), os.getenv("TOPICS_LEGACY_CUSTOMERS")]
BOOTSTRAP = os.getenv("KAFKA_BROKERCONNECT")
GROUP_ID = os.getenv("GROUP_ID")

def _validate_config():
    """
    Validate required Kafka configuration before creating the Consumer.
     Normal Python exception should be raised instead of code crash.
    """
    if not BOOTSTRAP:
        raise RuntimeError("KAFKA_BROKERCONNECT is not configured")

    if not GROUP_ID:
        raise RuntimeError("GROUP_ID is not configured")

    if not any(TOPICS):
        raise RuntimeError(
            "No topics configured: TOPICS_LEGACY_ORDERS / TOPICS_LEGACY_CUSTOMERS are empty"
        )



def create_consumer() -> Consumer:
    """
    Create and configure a Kafka consumer instance
    """

    _validate_config()
    
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
        topic=m.get("topic"),
        partition=m.get("partition"),
        offset=m.get("offset"),
    )


def _message_to_event(msg) -> CDCEvent | None:
    try:
        payload = json.loads(msg.value().decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as e:
        log.exception(
            "Failed to parse Kafka message as JSON",
            error=str(e),
            topic=msg.topic(),
            partition=msg.partition(),
            offset=msg.offset(),
        )
        return None

    return build_cdc_event({
        "key": msg.key(),
        "data": payload,
        "topic": msg.topic(),
        "partition": msg.partition(),
        "offset": msg.offset(),
    })


def _poll_batch(
    consumer: Consumer,
    max_messages: int = 50,
    poll_timeout: float = 1.0,
) -> list[CDCEvent]:
    events: list[CDCEvent] = []

    while len(events) < max_messages:
        msg = consumer.poll(poll_timeout)

        if msg is None:
            break

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

        event = _message_to_event(msg)
        if event is None:
            continue

        events.append(event)
        log.info(
            "Polled CDC message from legacy topic",
            source_topic=event.topic,
            partition=event.partition,
            offset=event.offset,
            pipeline_stage="cdc_consume",
            batch_size=len(events),
        )

    return events


def _process_polled_batch(
    consumer: Consumer,
    process_batch: Callable[[list[CDCEvent]], None],
) -> bool | None:
    batch = _poll_batch(consumer)
    if not batch:
        return None

    try:
        process_batch(batch)
        consumer.commit(asynchronous=False)
        log.info(
            "Committed CDC offsets after successful processing",
            batch_size=len(batch),
            topics=TOPICS,
            pipeline_stage="cdc_consume_commit",
        )
        return True
    except Exception as e:
        log.exception(
            "CDC batch processing failed; offsets were not committed",
            error=str(e),
            batch_size=len(batch),
        )
        return False


def consume_loop(process_batch: Callable[[list[CDCEvent]], None]):
    """
    Poll CDC messages, process them, and commit offsets after successful processing.
    """
    while True:
        consumer = None

        try:
            log.info("Creating new Kafka consumer...")
            consumer = create_consumer()
            consumer.subscribe(TOPICS)
            log.info("Subscribed to topics", topics=TOPICS)

            while True:
                result = _process_polled_batch(consumer, process_batch)
                if result is None:
                    time.sleep(3)
                    continue

                if result is False:
                    raise RuntimeError(
                        "CDC batch processing failed before offset commit"
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


def start_consumer_loop(process_batch: Callable[[list[CDCEvent]], None]):
    """
    Start the consumer loop in a background
    """
    log.info("Starting Kafka consumer thread...")
    t = threading.Thread(target=consume_loop, args=(process_batch,), daemon=True)
    t.start()
