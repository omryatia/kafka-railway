FROM confluentinc/cp-kafka:7.5.1

USER root

# Install Java and other dependencies for Kafka UI
RUN microdnf update -y && \
    microdnf install -y java-11-openjdk-headless curl nc && \
    microdnf clean all

# Set up Kafka UI
RUN mkdir -p /kafka-ui
ADD https://github.com/provectus/kafka-ui/releases/download/v0.7.1/kafka-ui-api-v0.7.1.jar /kafka-ui/kafka-ui-api.jar

# Create startup and health check scripts
COPY scripts/start.sh /usr/local/bin/
COPY scripts/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/healthcheck.sh

ENV KAFKA_NODE_ID=1 \
    KAFKA_PROCESS_ROLES=broker,controller \
    KAFKA_CONTROLLER_QUORUM_VOTERS=1@localhost:29093 \
    KAFKA_LISTENERS=PLAINTEXT://:29092,CONTROLLER://:29093,EXTERNAL://:9092 \
    KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:29092,EXTERNAL://${RAILWAY_PUBLIC_DOMAIN}:${PORT} \
    KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT \
    KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER \
    KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT \
    KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
    KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
    KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
    KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
    KAFKA_AUTO_CREATE_TOPICS_ENABLE=true \
    KAFKA_CLUSTERS_0_NAME=local \
    KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=localhost:29092

EXPOSE 9092 8080

HEALTHCHECK --interval=5s --timeout=10s --retries=5 \
    CMD /usr/local/bin/healthcheck.sh

CMD ["/usr/local/bin/start.sh"]
