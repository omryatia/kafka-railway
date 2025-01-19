# Kafka Railway Template

Ready-to-deploy Kafka template for Railway.app with Kafka UI.

## Features

- Apache Kafka with KRaft (no Zookeeper needed)
- Kafka UI for management and monitoring
- Configurable through environment variables
- Health checks for both services
- Proper service dependencies

## Quick Start

1. Click "Deploy to Railway" button
2. Set required environment variables
3. Deploy!

## Environment Variables

### Required:
- `RAILWAY_PUBLIC_DOMAIN`: Your Railway domain (provided by Railway)

### Optional:
- `KAFKA_PORT`: Kafka port (default: 9092)
- `UI_PORT`: Kafka UI port (default: 8080)
- `CLUSTER_NAME`: Kafka cluster name (default: local)

## Local Development

1. Copy environment file:
```bash
cp .env.example .env
```

2. Start services:
```bash
docker-compose up -d
```

3. Access:
- Kafka: localhost:9092
- Kafka UI: http://localhost:8080

## Health Checks

Both services include health checks:
- Kafka: Checks if topics can be listed
- Kafka UI: Checks if health endpoint responds

## Connection Details

### Internal (Container-to-Container)
- Bootstrap Server: `kafka:29092`

### External
- Bootstrap Server: `${RAILWAY_PUBLIC_DOMAIN}:9092`
- Kafka UI: `https://<your-railway-domain>:8080`

## Architecture

- Uses KRaft instead of Zookeeper
- Separate containers for Kafka and UI
- Internal and external listeners
- Proper startup order with health checks
