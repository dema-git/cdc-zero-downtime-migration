# app/consumer.py
import threading
import json
from collections import defaultdict
from confluent_kafka import Consumer, TopicPartition
import logging
from .models import Source, CDCEvent

logger = logging.getLogger("app.consumer")

TOPICS = ["cdc.public.legacy_orders", "cdc.public.legacy_customers"]
BOOTSTRAP = "kafka:9092"
GROUP_ID = "time-window-consumer"


consumer = Consumer({
    "bootstrap.servers": BOOTSTRAP,
    "group.id": GROUP_ID,
    "enable.auto.commit": False,
    "auto.offset.reset": "earliest"
})

consumer.subscribe(TOPICS)

# message queue for FastAPI
message_queue = []
queue_lock = threading.Lock()


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

def consume_loop():
    while True:
        msg = consumer.poll(1.0)

        if msg is None:
            continue
        if msg.error():
            continue

        payload = json.loads(msg.value().decode("utf-8"))


        with queue_lock:
            message_queue.append({
                "key": msg.key(),
                "data": payload,
                "topic": msg.topic(),
                "partition": msg.partition(),
                "offset": msg.offset()
            })


def start_consumer_loop():
    threading.Thread(
        target=consume_loop,
        daemon=True
    ).start()


def get_messages() -> list[CDCEvent]:
    with queue_lock:
        if not message_queue:
            return []

        batch = message_queue.copy()
        message_queue.clear()

    results: list[CDCEvent] = []

    offsets: dict[tuple[str, int], int] = defaultdict(lambda: -1)

    for msg in batch:

        event = build_cdc_event(msg)
        results.append(event)

        key = (msg["topic"], msg["partition"])
        if msg["offset"] > offsets[key]:
            offsets[key] = msg["offset"]

    if offsets:
        tps = [
            TopicPartition(topic, partition, offset + 1)
            for (topic, partition), offset in offsets.items()
        ]
        consumer.commit(offsets=tps)

    return results