# app/consumer.py
import threading
import json
from collections import defaultdict
from confluent_kafka import Consumer, TopicPartition
import logging

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


def consume_loop():
    # Background consumer: read messages and add to queue
    while True:
        msg = consumer.poll(1.0)

        if msg is None:
            continue
        if msg.error():
            continue

        payload = json.loads(msg.value().decode("utf-8"))


        with queue_lock:
            message_queue.append({
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


def get_messages():

    # Safely take all messages from the queue
    with queue_lock:
        if not message_queue:
            return []

        batch = message_queue.copy()
        message_queue.clear()

    data_batch = [m["data"] for m in batch]


    # Collect the highest processed offset per topic-partition
    offsets = defaultdict(lambda: -1)

    for m in batch:
        key = (m["topic"], m["partition"])
        offsets[key] = max(offsets[key], m["offset"])

    # Commit offsets
    # Kafka expects the NEXT offset to be committed
    tps = [
        TopicPartition(topic, partition, offset + 1)
        for (topic, partition), offset in offsets.items()
    ]

    consumer.commit(offsets=tps)

    return data_batch