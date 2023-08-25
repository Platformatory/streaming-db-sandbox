CREATE TABLE temperature_readings (
    timestamp timestamp,
    sensor_id int,
    temperature float
) WITH ( 
    connector = 'kafka',
    topic = 'temperature_readings',
    properties.bootstrap.server = '',
    scan.startup.mode = 'earliest', 
    properties.security.protocol = 'SASL_SSL', 
    properties.sasl.mechanism = 'PLAIN', 
    properties.sasl.username = '', 
    properties.sasl.password = ''
) FORMAT PLAIN ENCODE JSON;

-- Check the input data
-- SELECT * FROM temperature_readings LIMIT 10 ;


CREATE MATERIALIZED VIEW temperature_conversion AS
SELECT
    *,
    temperature * 9/5 + 32 AS temperature_fahrenheit
FROM temperature_readings;

-- Check the converted data
-- SELECT * FROM temperature_conversion;

-- SELECT sensor_id, AVG(temperature) AS avg_temperature, window_start, window_end
-- FROM TUMBLE (temperature_readings, timestamp, INTERVAL '5 SECONDS');

-- CREATE SINK json_sink FROM temperature_conversion 
-- WITH (
--    connector='kafka',
--    type='append-only',
--    properties.bootstrap.server = '',
--    properties.security.protocol = 'SASL_SSL', 
--    properties.sasl.mechanism = 'PLAIN', 
--    properties.sasl.username = '', 
--    properties.sasl.password = '',
--    topic='temperature_converted_rising_wave'
-- );