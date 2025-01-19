FROM docker:24.0.7-dind

# Install required packages
RUN apk add --no-cache \
    docker-compose \
    curl \
    bash

# Copy project files
COPY . /app/
WORKDIR /app

# Create startup script
RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'dockerd --storage-driver=vfs &' >> /app/start.sh && \
    echo 'while ! docker info > /dev/null 2>&1; do sleep 1; done' >> /app/start.sh && \
    echo 'docker-compose up --build' >> /app/start.sh && \
    chmod +x /app/start.sh

EXPOSE 9092 8080

# Start with privileged mode
ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD ["/app/start.sh"]
