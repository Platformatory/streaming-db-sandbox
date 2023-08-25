CREATE SECRET confluent_username AS :'username';
CREATE SECRET confluent_password AS :'password';

CREATE CONNECTION confluent_cloud TO KAFKA (
BROKER :'bootstrap_servers',
SASL MECHANISMS = 'PLAIN',
SASL USERNAME = SECRET confluent_username,
SASL PASSWORD = SECRET confluent_password,
PROGRESS TOPIC = 'materialize_progress'
);

CREATE SOURCE temperature_readings
FROM KAFKA CONNECTION confluent_cloud (TOPIC 'temperature_readings')
FORMAT JSON
WITH (SIZE = '32');

-- Format the input data
CREATE VIEW temperature_json AS
  SELECT
    (data->>'timestamp')::int AS record_timestamp,
    (data->>'sensor_id')::int AS sensor_id,
    (data->>'temperature')::float AS temperature
  FROM temperature_readings;

-- Check the input data
-- SELECT * FROM temperature_json;

CREATE MATERIALIZED VIEW temperature_conversion AS
SELECT
    *,
    temperature * 9/5 + 32 AS temperature_fahrenheit
FROM temperature_json;

-- Check the converted data
-- SELECT * FROM temperature_conversion;


CREATE SINK json_sink
  FROM temperature_conversion
  INTO KAFKA CONNECTION confluent_cloud (TOPIC 'temperature_converted_materialize')
  FORMAT JSON
  ENVELOPE UPSERT
  WITH (SIZE = '32');