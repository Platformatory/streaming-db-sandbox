# Rising Wave Playground

Docker compose environment for running Rising Wave with Confluent Cloud

### Environment Variables

```bash
export KAFKA_TOPIC=temperature_readings
export KAFKA_BOOTSTRAP_SERVERS=
export KAFKA_SASL_USERNAME=
export KAFKA_SASL_PASSWORD=
export KAFKA_OUTPUT_TOPIC=temperature_converted_rising_wave
```


### Start

```
docker-compose up -d
```
