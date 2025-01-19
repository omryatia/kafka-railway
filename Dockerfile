version: '3.8'
services:
  kafka:
    build: kafka
    ports:
      - "${KAFKA_PORT:-9092}:9092"
    environment:
      RAILWAY_PUBLIC_DOMAIN: ${RAILWAY_PUBLIC_DOMAIN:-localhost}
      PORT: ${KAFKA_PORT:-9092}
    healthcheck:
      test: ["CMD-SHELL", "/usr/local/bin/healthcheck.sh"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 15s

  kafka-ui:
    build: kafka-ui
    ports:
      - "${UI_PORT:-8080}:8080"
    environment:
      KAFKA_CLUSTERS_0_NAME: ${CLUSTER_NAME:-local}
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka:29092
    depends_on:
      kafka:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "/usr/local/bin/healthcheck.sh"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 15s
