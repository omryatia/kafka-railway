FROM confluentinc/cp-kafka:7.8.0

# Copy server properties for Kafka Kraft mode
COPY server.properties /etc/kafka/server.properties

# Expose Kafka port
EXPOSE 9092

# Start Kafka with custom configuration
CMD ["bash", "-c", "/etc/confluent/docker/run"]
