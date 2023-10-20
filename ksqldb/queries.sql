SET 'auto.offset.reset' = 'earliest';
SET 'ksql.streams.auto.offset.reset' = 'earliest';

-- Create a KSQL stream from the Kafka topic
CREATE STREAM temperature_stream_1 (sensor_id INT, temperature DOUBLE, timestamp BIGINT)
WITH (KAFKA_TOPIC='temperature_readings', VALUE_FORMAT='JSON');

-- Create a derived stream with Celsius to Fahrenheit conversion
CREATE STREAM temperature_fahrenheit_stream_1 AS
SELECT
    sensor_id,
    temperature,
    (temperature * 9/5) + 32 AS temperature_fahrenheit,
    timestamp
FROM temperature_stream;

-- Show the results
-- SELECT * FROM temperature_fahrenheit_stream EMIT CHANGES;

-- Create a tumbling windowed stream to calculate average temperature
CREATE TABLE avg_temperature_table AS
SELECT
    sensor_id,
    AVG(temperature) AS avg_temperature
FROM temperature_stream
WINDOW TUMBLING (SIZE 5 SECONDS)
GROUP BY sensor_id;

-- Show the results
-- SELECT * FROM avg_temperature_table EMIT CHANGES;