CREATE TABLE temperature_readings (
    timestamp timestamp,
    sensor_id int,
    temperature float
) WITH ( 
    connector = 'kafka',
    topic = 'temperature_readings',
    properties.bootstrap.server = :'bootstrap_servers',
    scan.startup.mode = 'earliest', 
    properties.security.protocol = 'SASL_SSL', 
    properties.sasl.mechanism = 'PLAIN', 
    properties.sasl.username = :'username', 
    properties.sasl.password = :'password'
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

CREATE SINK temperature_conversion_sink FROM temperature_conversion 
WITH (
   connector='kafka',
   type='upsert',
   primary_key='timestamp',
   properties.bootstrap.server = :'bootstrap_servers',
   properties.security.protocol = 'SASL_SSL', 
   properties.sasl.mechanism = 'PLAIN', 
   properties.sasl.username = :'username', 
   properties.sasl.password = :'password',
   topic='temperature_converted_rising_wave'
);

-- Average temperature for each minute
CREATE MATERIALIZED VIEW avg_temperature AS
SELECT
    sensor_id,
    window_start,
    window_end,
    AVG(temperature) AS avg_temperature
FROM
    TUMBLE(
        temperature_readings,
        timestamp,
        INTERVAL '1' MINUTE
    )
GROUP BY
    sensor_id, window_start, window_end;

-- Check the converted data
-- SELECT * FROM avg_temperature;
    

CREATE SINK avg_temperature_sink FROM avg_temperature 
WITH (
   connector='kafka',
   type='upsert',
   primary_key='window_start,window_end',
   properties.bootstrap.server = :'bootstrap_servers',
   properties.security.protocol = 'SASL_SSL', 
   properties.sasl.mechanism = 'PLAIN', 
   properties.sasl.username = :'username', 
   properties.sasl.password = :'password',
   topic='avg_temperature_rising_wave'
);