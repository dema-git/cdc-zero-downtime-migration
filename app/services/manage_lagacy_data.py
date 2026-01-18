from app.models import CDCEvent
from confluent_kafka import Producer
import json


conf = {'bootstrap.servers': 'kafka:9092'}
producer = Producer(conf)
topic = "cleared_customers"



def before_data(data: dict):
    table = data.get("table")
    for item in data.get("data", []):
        print("item:", item)
        print("table:", table)


def after_data(data: dict):
    table = data.get("table")
    for item in data.get("data", []):
        print("item:", item)
        print("table:", table)


def manage_legacy_data_main(data_batch: list[CDCEvent]) -> None:
    for event in data_batch:
        if event.table_name != "legacy_customers":
            continue

        changed = event.split_full_name()
        if not changed:
            continue

        value = event.to_message()

        value_bytes = json.dumps(value).encode("utf-8")
        key_bytes = (
            json.dumps(event.key).encode("utf-8")
            if event.key is not None
            else None
        )

        producer.produce(topic=topic, key=key_bytes, value=value_bytes)

    producer.flush(5)

