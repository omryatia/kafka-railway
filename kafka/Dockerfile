FROM confluentinc/cp-kafka:7.8.0

# Copy Kraft configuration
COPY server.properties /etc/kafka/server.properties

# Generate and initialize the cluster ID
RUN export KAFKA_CLUSTER_ID=$(kafka-storage.sh random-uuid) && \
    kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c /etc/kafka/server.properties

# Expose Kafka ports
EXPOSE 9092 9093

# Set the default command
CMD ["/etc/confluent/docker/run"]
