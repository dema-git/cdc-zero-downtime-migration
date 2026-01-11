#!/bin/bash

CONNECT_HOST=$1
CONNECT_PORT=$2
CONNECT_JSON_FILE=$3

echo "Waiting 10 seconds for Kafka Connect to stabilize..."
sleep 10
echo "Kafka Connect REST is up!"

CONNECT_NAME=$(jq -r '.name' "$CONNECT_JSON_FILE")

EXISTS=$(curl -s "http://$CONNECT_HOST:$CONNECT_PORT/connectors" | jq -r ".[] | select(.==\"$CONNECT_NAME\")")

if [ -z "$EXISTS" ]; then
    echo "Creating connector $CONNECT_NAME..."
    curl -X POST "http://$CONNECT_HOST:$CONNECT_PORT/connectors" \
        -H "Content-Type: application/json" \
        -d @"$CONNECT_JSON_FILE"
    echo "Connector $CONNECT_NAME created."
else
    echo "Connector $CONNECT_NAME already exists."
fi
