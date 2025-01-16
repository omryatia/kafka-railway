#!/bin/sh

# Check Kafka
kafka-topics --bootstrap-server localhost:29092 --list > /dev/null 2>&1
KAFKA_STATUS=$?

# Check Kafka UI
curl -f http://localhost:8080/api/health > /dev/null 2>&1
UI_STATUS=$?

# Both services need to be healthy
[ $KAFKA_STATUS -eq 0 ] && [ $UI_STATUS -eq 0 ]
exit $?
