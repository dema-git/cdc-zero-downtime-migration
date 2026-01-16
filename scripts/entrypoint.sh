#!/bin/bash
set -e

BROKER="kafka:9092"

TOPICS=("topic1" "topic2" "topic3")

echo "Waiting for Kafka broker at $BROKER..."
until kafka-topics.sh --bootstrap-server $BROKER --list >/dev/null 2>&1; do
  echo "Kafka not ready yet, sleeping 2 seconds..."
  sleep 2
done
echo "Kafka is up!"


for topic in "${TOPICS[@]}"; do
  echo "Creating topic $topic..."
  kafka-topics.sh --bootstrap-server $BROKER \
    --create --if-not-exists \
    --partitions 3 \
    --replication-factor 1 \
    --topic "$topic"
done

echo "All topics checked/created!"

exec /bin/bash
