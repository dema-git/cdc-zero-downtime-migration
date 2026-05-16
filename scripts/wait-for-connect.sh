#!/bin/bash

CONNECT_HOST=$1
CONNECT_PORT=$2
CONNECT_TEMPLATE_FILE=$3
CONNECT_JSON_FILE="/tmp/connector.json"
CONNECT_URL="http://$CONNECT_HOST:$CONNECT_PORT"
CONNECT_ENV_VARS='${KAFKA_SOURCE_CONNECTOR} ${KAFKA_SINK_CONNECTOR} ${POSTGRES_LEGACY_USER} ${POSTGRES_LEGACY_PASSWORD} ${POSTGRES_CLEAN_USER} ${POSTGRES_CLEAN_PASSWORD}'

echo "Waiting for Kafka Connect REST at $CONNECT_URL..."
until curl -fsS "$CONNECT_URL/connectors" >/dev/null 2>&1; do
  echo "Kafka Connect REST is not ready yet, sleeping 2 seconds..."
  sleep 2
done
echo "Kafka Connect REST is up!"

echo "Rendering connector config from $CONNECT_TEMPLATE_FILE..."
envsubst "$CONNECT_ENV_VARS" < "$CONNECT_TEMPLATE_FILE" > "$CONNECT_JSON_FILE"

CONNECT_NAME=$(jq -r '.name' "$CONNECT_JSON_FILE")

EXISTS=$(curl -s "$CONNECT_URL/connectors" | jq -r ".[] | select(.==\"$CONNECT_NAME\")")

if [ -z "$EXISTS" ]; then
    echo "Creating connector $CONNECT_NAME..."
    curl -fsS -o /tmp/connector-response.json -X POST "$CONNECT_URL/connectors" \
        -H "Content-Type: application/json" \
        -d @"$CONNECT_JSON_FILE"
    echo "Connector $CONNECT_NAME created."
else
    echo "Connector $CONNECT_NAME already exists."
fi
