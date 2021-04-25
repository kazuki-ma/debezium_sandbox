#!zsh

curl -vs 'http://localhost:8083/'

curl -vs -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d'
{
  "name": "debezium_example", 
  "config": { 
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1", 
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "false",
    "value.converter":"org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "false",
    "database.allowPublicKeyRetrieval": "true",
    "database.hostname": "mysql", 
    "database.port": "3306",
    "database.user": "root",
    "database.password": "",
    "database.server.id": "100", 
    "database.server.name": "mysql", 
    "database.include.list": "", 
    "include.query": true,
    "transforms":"all",
    "transforms.all.type":"io.debezium.transforms.ByLogicalTableRouter",
    "transforms.all.topic.regex":".*",
    "transforms.all.topic.replacement":"debezium_binlog",
    "snapshot.mode": "SCHEMA_ONLY",
    "snapshot.locking.mode": "none",
    "database.history.kafka.bootstrap.servers": "kafka:9092",
    "database.history.kafka.topic": "debezium_history_v2"
  }
}
'

  # "database.history.kafka.bootstrap.servers": "kafka:9092",
  # "database.history.kafka.topic": "debezium_history"
  #  "database.history": "io.debezium.relational.history.FileDatabaseHistory",
  #  "database.history.file.filename": "/database_history/debezium_example"
curl -vs 'http://localhost:8083/connectors/debezium_example' | jq . -S