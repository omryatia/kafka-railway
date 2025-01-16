FROM provectuslabs/kafka-ui:latest as kafka-ui
FROM confluentinc/cp-kafka:latest

USER root

# Copy Kafka UI from the first stage
COPY --from=kafka-ui /kafka-ui-api.jar /kafka-ui/kafka-ui-api.jar

# Install OpenJDK for Kafka UI
RUN yum update -y && \
    yum install -y java-11-openjdk-headless && \
    yum clean all

# Create directories
RUN mkdir -p /opt/kafka/data /opt/kafka/logs

# Copy health check script
COPY scripts/healthcheck.sh /usr/local/bin/
COPY scripts/start-services.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh /usr/local/bin/start-services.sh

EXPOSE 9092 29092 29093 8080

# Set environment variables for Kafka
ENV KAFKA_NODE_ID=1
ENV KAFKA_PROCESS_ROLES=broker,controller
ENV KAFKA_CONTROLLER_QUORUM_VOTERS=1@kafka:29093
ENV KAFKA_LISTENERS=PLAINTEXT://:29092,CONTROLLER://:29093,EXTERNAL://:9092
ENV KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:29092,EXTERNAL://${RAILWAY_PUBLIC_DOMAIN}:${PORT}
ENV KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT
ENV KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
ENV KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT

# Other Kafka configurations
ENV KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1
ENV KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0
ENV KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1
ENV KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1
ENV KAFKA_AUTO_CREATE_TOPICS_ENABLE=true

# Kafka UI Configuration
ENV KAFKA_CLUSTERS_0_NAME=local
ENV KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=localhost:29092

VOLUME ["/opt/kafka/data", "/opt/kafka/logs"]

HEALTHCHECK --interval=5s --timeout=10s --retries=5 \
    CMD /usr/local/bin/healthcheck.sh

CMD ["/usr/local/bin/start-services.sh"]
