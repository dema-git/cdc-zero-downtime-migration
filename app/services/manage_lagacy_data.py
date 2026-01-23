######################################################################
# manage_legacy_data.py
#
# This module processes legacy CDC events and transforms them before
# sending them to Kafka.
# It handles customer and order events, normalizing fields and preparing messages
# for downstream services.
# Each event type is routed to the appropriate handler based on the table name.
######################################################################
from app.logging_config import AppLogger
from app.models import CDCEvent
from confluent_kafka import Producer, KafkaException
import json

log = AppLogger(component="legacy_data")

conf = {'bootstrap.servers': 'kafka:9092'}
producer = Producer(conf)
topic = "cleared_customers"

# TOPICS
TOPIC_CUSTOMERS = "cleared_customers"
TOPIC_ORDERS = "cleared_orders"

# Mapping of warehouse city names to warehouse IDs.
# These IDs correspond to the warehouse entries in the clean database.
WAREHOUSE_CITY_TO_ID = {
    "Berlin": 1,
    "Paris": 2,
    "Madrid": 3,
    "Rome": 4,
    "Amsterdam": 5,
    "Vienna": 6,
    "Prague": 7,
    "Warsaw": 8,
    "Stockholm": 9,
    "Helsinki": 10,
}

def manage_legacy_orders(event: CDCEvent) -> None:
    """
    Processes legacy order events by normalizing warehouse data
    and publishing them to Kafka.
    """
    if event.table_name != "legacy_orders":
        return

    changed = event.normalize_warehouse(WAREHOUSE_CITY_TO_ID)
    if not changed:
        return

    value = event.to_message()
    value_bytes = json.dumps(value).encode("utf-8")
    key_bytes = (
        json.dumps(event.key).encode("utf-8")
        if event.key is not None
        else None
    )
    try:
        producer.produce(topic=TOPIC_ORDERS, key=key_bytes, value=value_bytes)
    except KafkaException as e:
        log.exception(
            "Failed to produce legacy order event",
            error=str(e),
            topic=TOPIC_ORDERS,
            table_name=event.table_name,
            key=event.key,
        )

def manage_legacy_customers(event: CDCEvent) -> None:
    """
    Handles legacy customer events by splitting full names
    and producing the updated data to Kafka.
    """
    if event.table_name != "legacy_customers":
        return

    changed = event.split_full_name()
    if not changed:
        return

    value = event.to_message()

    value_bytes = json.dumps(value).encode("utf-8")
    key_bytes = (
        json.dumps(event.key).encode("utf-8")
        if event.key is not None
        else None
    )
    try:
        producer.produce(topic=TOPIC_CUSTOMERS, key=key_bytes, value=value_bytes)
    except KafkaException as e:
        log.exception(
            "Failed to produce legacy customer event",
            error=str(e),
            topic=TOPIC_CUSTOMERS,
            table_name=event.table_name,
            key=event.key,
        )

TABLE_HANDLERS: dict = {
    "legacy_customers": manage_legacy_customers,
    "legacy_orders": manage_legacy_orders,
}


def manage_legacy_data_main(data_batch: list[CDCEvent]) -> None:
    """
    Dispatches CDC events to their corresponding handlers
    and ensures all Kafka messages are flushed.
    """
    log.info("Processing CDC batch", batch_size=len(data_batch))

    processed_count = 0
    skipped_count = 0
    for event in data_batch:
        handler = TABLE_HANDLERS.get(event.table_name)
        if handler is None:
            continue
        handler(event)

        processed_count += 1
    try:
        producer.flush(5)
        log.info(
            "Kafka producer flush completed",
            flush_timeout_seconds=5,
            processed_count=processed_count,
            skipped_count=skipped_count,
            batch_size=len(data_batch),
        )
    except KafkaException as e:
        log.exception(
            "Kafka producer flush failed",
            error=str(e),
            processed_count=processed_count,
            skipped_count=skipped_count,
            batch_size=len(data_batch),
        )

