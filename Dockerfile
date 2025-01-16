FROM docker:24.0.7-dind

# Install required packages
RUN apk add --no-cache \
    docker-compose \
    curl

# Copy configuration files
COPY docker/docker-compose.yml /app/
COPY railway.toml /app/

WORKDIR /app

# Create health check endpoint
RUN echo '#!/bin/sh' > /app/health.sh && \
    echo 'curl -f http://localhost:${UI_PORT:-8080} || exit 1' >> /app/health.sh && \
    chmod +x /app/health.sh

EXPOSE ${PORT:-9092} ${UI_PORT:-8080}

# Start Docker daemon and docker-compose
CMD ["dockerd-entrypoint.sh"]
