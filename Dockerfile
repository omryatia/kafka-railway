FROM docker:24.0.7-dind

# Install required packages
RUN apk add --no-cache \
    docker-compose \
    curl

# Copy project files
COPY . /app/
WORKDIR /app

# Create startup script
RUN echo '#!/bin/sh' > /app/start.sh && \
    echo 'dockerd &' >> /app/start.sh && \
    echo 'sleep 5' >> /app/start.sh && \
    echo 'docker-compose up' >> /app/start.sh && \
    chmod +x /app/start.sh

EXPOSE 9092 8080

CMD ["/app/start.sh"]
