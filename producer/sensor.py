from confluent_kafka import SerializingProducer
import json
import random
import time
import os

def json_serializer(msg, s_obj):
    return json.dumps(msg).encode('utf-8')

# Configure Kafka producer
conf = {
    'bootstrap.servers': os.getenv('KAFKA_BOOTSTRAP_SERVERS'),
    'security.protocol': 'SASL_SSL',
    'sasl.mechanism': 'PLAIN',
    'sasl.username': os.getenv('KAFKA_SASL_USERNAME'),
    'sasl.password': os.getenv('KAFKA_SASL_PASSWORD'),
    'value.serializer': json_serializer
}

producer = SerializingProducer(conf)

# Produce temperature readings
while True:
    temperature = round(random.uniform(20, 30), 2)
    sensor_id = random.randrange(10)
    message = {'sensor_id': sensor_id, 'temperature': temperature, 'timestamp': int(time.time())}
    producer.produce(topic=os.getenv('KAFKA_TOPIC'),
        key=str(sensor_id),
        value=message)
    print(f"Produced temperature reading: {message}")
    producer.flush()
    time.sleep(1)

# Close the producer (not executed in this infinite loop example)
producer.close()
