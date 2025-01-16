#!/bin/sh

# Start Kafka in the background
/etc/confluent/docker/run &

# Wait for Kafka to start
sleep 10

# Start Kafka UI
java -jar /kafka-ui/kafka-ui-api.jar &

# Keep container running
wait
