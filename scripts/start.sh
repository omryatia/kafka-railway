#!/bin/bash

# Enable debug mode
set -x

# Function to check if a port is open
check_port() {
    nc -z localhost $1 > /dev/null 2>&1
}

# Generate a random CLUSTER_ID if not set
if [ -z "$CLUSTER_ID" ]; then
    export CLUSTER_ID=$(kafka-storage random-uuid)
    echo "Generated CLUSTER_ID: $CLUSTER_ID"
fi

# Format storage directory
echo "Formatting storage directory with CLUSTER_ID: $CLUSTER_ID"
kafka-storage format -t $CLUSTER_ID -c /etc/kafka/kraft/server.properties

# Start Kafka with logging
echo "Starting Kafka..."
/etc/confluent/docker/run > /tmp/kafka.log 2>&1 &
KAFKA_PID=$!

# Wait for Kafka to start with more detailed checks
echo "Waiting for Kafka to start..."
COUNTER=0
MAX_TRIES=30

while [ $COUNTER -lt $MAX_TRIES ]; do
    echo "Attempt $((COUNTER+1)) of $MAX_TRIES"
    
    # Check if process is still running
    if ! kill -0 $KAFKA_PID 2>/dev/null; then
        echo "Kafka process died. Last logs:"
        tail -n 50 /tmp/kafka.log
        exit 1
    fi

    # Check all required ports
    if check_port 29092 && check_port 9092 && check_port 29093; then
        echo "All Kafka ports are open"
        
        # Try to list topics
        if kafka-topics --bootstrap-server localhost:29092 --list >/dev/null 2>&1; then
            echo "Kafka is fully operational!"
            break
        fi
    fi

    # Show recent logs
    echo "Recent Kafka logs:"
    tail -n 5 /tmp/kafka.log

    COUNTER=$((COUNTER+1))
    sleep 10
done

if [ $COUNTER -eq $MAX_TRIES ]; then
    echo "Failed to start Kafka after $MAX_TRIES attempts"
    echo "Full Kafka logs:"
    cat /tmp/kafka.log
    exit 1
fi

# Start Kafka UI
echo "Starting Kafka UI..."
java -jar /kafka-ui/kafka-ui-api.jar > /tmp/kafka-ui.log 2>&1 &
UI_PID=$!

# Monitor both processes
while true; do
    if ! kill -0 $KAFKA_PID 2>/dev/null; then
        echo "Kafka process died. Last logs:"
        tail -n 50 /tmp/kafka.log
        exit 1
    fi
    if ! kill -0 $UI_PID 2>/dev/null; then
        echo "Kafka UI process died. Last logs:"
        tail -n 50 /tmp/kafka-ui.log
        exit 1
    fi
    sleep 5
done
