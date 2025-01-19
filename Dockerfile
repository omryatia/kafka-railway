FROM docker/compose:1.29.2

WORKDIR /app

# Copy docker-compose file
COPY docker-compose.yml .

# Install curl for healthcheck
RUN apk add --no-cache curl

EXPOSE 9092 8080

CMD ["docker-compose", "up"]
