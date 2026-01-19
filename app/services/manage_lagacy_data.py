from app.models import CDCEvent
from confluent_kafka import Producer
import json


conf = {'bootstrap.servers': 'kafka:9092'}
producer = Producer(conf)
topic = "cleared_customers"


TOPIC_CUSTOMERS = "cleared_customers"
TOPIC_ORDERS = "cleared_orders"


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

    producer.produce(topic=TOPIC_ORDERS, key=key_bytes, value=value_bytes)


def manage_legacy_customers(event: CDCEvent) -> None:
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

    producer.produce(topic=TOPIC_CUSTOMERS, key=key_bytes, value=value_bytes)


TABLE_HANDLERS: dict = {
    "legacy_customers": manage_legacy_customers,
    "legacy_orders": manage_legacy_orders,
}

def manage_legacy_data_main(data_batch: list[CDCEvent]) -> None:
    for event in data_batch:
        handler = TABLE_HANDLERS.get(event.table_name)
        if handler is None:
            continue
        handler(event)

    producer.flush(5)
