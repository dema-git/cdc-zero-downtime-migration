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


def manage_legacy_data_main(data_batch: list[CDCEvent]):
    for event in data_batch:
        if event.table_name == 'legacy_customers':
            data_to_send = event.with_split_name()
            producer.produce(topic, json.dumps(data_to_send).encode("utf-8"))

    producer.flush()
