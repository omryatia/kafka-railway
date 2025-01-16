# Kafka Railway Deployment

Apache Kafka deployment configured for Railway.app platform with KRaft (no Zookeeper) and Kafka UI.

## Features

- Single-node Kafka broker with KRaft (no Zookeeper needed)
- Kafka UI for monitoring and management
- Configured for Railway.app deployment
- Health checks for both Kafka and UI

## Deployment

1. Create new Railway project:
```bash
railway init
```

2. Set environment variables in Railway dashboard:
```
PORT=9092               # Kafka broker port
UI_PORT=8080           # Kafka UI port
RAILWAY_STATIC_URL     # Provided by Railway
```

3. Deploy to Railway:
```bash
railway up
```

## Connecting to Kafka

After deployment, your Kafka broker will be available at:
- Bootstrap server: `${RAILWAY_STATIC_URL}:9092`
- Kafka UI: `https://<your-railway-domain>:8080`

## Configuration

The Kafka broker is configured with:
- KRaft for metadata management (no Zookeeper)
- Single node setup
- Auto topic creation enabled
- Replication factor of 1
- Health checks for both Kafka and UI

## Local Development

To run locally:

```bash
cd docker
docker-compose up -d
```

Access:
- Kafka broker at `localhost:9092`
- Kafka UI at `http://localhost:8080`
