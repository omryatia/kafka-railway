FROM docker:24.0.7-dind

# Install required packages
RUN apk add --no-cache \
    docker-compose \
    curl

# Copy project files
COPY . /app/
WORKDIR /app

EXPOSE 9092 8080

CMD ["docker-compose", "up"]
