#!/bin/bash

# Start Kafka
echo "Starting Kafka..."
/etc/confluent/docker/run &
KAFKA_PID=$!

# Wait for Kafka to start
echo "Waiting for Kafka to start..."
until echo exit | kafka-topics --bootstrap-server localhost:29092 --list >/dev/null 2>&1
do
    echo "Waiting for Kafka to be ready..."
    sleep 2
done

# Start Kafka UI
echo "Starting Kafka UI..."
java -jar /kafka-ui/kafka-ui-api.jar &
UI_PID=$!

# Wait for either process to exit
wait -n $KAFKA_PID $UI_PID
EXIT_CODE=$?

# If either process exits, kill the other and exit with the same code
if [ $EXIT_CODE -ne 0 ]; then
    echo "One of the services failed, shutting down..."
    kill $KAFKA_PID $UI_PID 2>/dev/null
fi

exit $EXIT_CODE
