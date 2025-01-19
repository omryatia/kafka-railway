FROM confluentinc/cp-kafka:7.5.1

# Copy Kraft server properties
COPY server.properties /etc/kafka/server.properties

# Expose ports
EXPOSE 9092 9093

# Set environment variables for Kraft mode
ENV KAFKA_PROCESS_ROLES="broker,controller"
ENV KAFKA_NODE_ID=1
ENV KAFKA_CONTROLLER_QUORUM_VOTERS="1@localhost:9093"
ENV KAFKA_LISTENERS="PLAINTEXT://:9092,CONTROLLER://:9093"
ENV KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://localhost:9092"
ENV KAFKA_LOG_DIRS="/var/lib/kafka/data"

# Use the default entrypoint
CMD ["/etc/confluent/docker/run"]
