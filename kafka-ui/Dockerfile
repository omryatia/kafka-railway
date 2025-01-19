FROM provectuslabs/kafka-ui:latest

COPY healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

ENV KAFKA_CLUSTERS_0_NAME=local \
    KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka:29092

EXPOSE 8080

HEALTHCHECK --interval=5s --timeout=10s --retries=5 \
    CMD /usr/local/bin/healthcheck.sh
