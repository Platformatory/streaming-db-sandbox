# Materialize Playground

Docker compose environment for running Materialize with Confluent Cloud

### Environment Variables

```bash
export KAFKA_TOPIC=temperature_readings
export KAFKA_BOOTSTRAP_SERVERS=
export KAFKA_SASL_USERNAME=
export KAFKA_SASL_PASSWORD=
export KAFKA_OUTPUT_TOPIC=temperature_converted_materialize
export KAFKA_AVG_OUTPUT_TOPIC=avg_temperature_materialize
```


### Start

```
docker-compose up -d
```


### Materialize Gotchas

- Sizing source and sinks
- Lack of headless mode