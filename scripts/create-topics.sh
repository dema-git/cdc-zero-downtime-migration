#!/bin/bash
set -e

BROKER="kafka:9092"
TOPICS=("topic1" "topic2" "topic3")

echo "Waiting 10 seconds for Kafka..."
sleep 10

KAFKA_BIN="/opt/kafka_2.13-3.7.2/bin"

for topic in "${TOPICS[@]}"; do
  echo "Creating topic $topic..."
  "$KAFKA_BIN/kafka-topics.sh" --bootstrap-server "$BROKER" \
    --create --if-not-exists \
    --partitions 3 --replication-factor 1 \
    --topic "$topic"
done

echo "All topics checked/created!"