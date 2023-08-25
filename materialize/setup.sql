CREATE SECRET confluent_username AS '';
CREATE SECRET confluent_password AS '';

CREATE CONNECTION confluent_cloud TO KAFKA (
BROKER '',
SASL MECHANISMS = 'PLAIN',
SASL USERNAME = SECRET confluent_username,
SASL PASSWORD = SECRET confluent_password,
PROGRESS TOPIC = 'materialize_progress'
);