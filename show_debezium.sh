#!/bin/zsh

echo "docker exec kafka ./bin/kafka-console-consumer.sh --bootstrap-server=kafka:9092 --topic=debezium_binlog --consumer-property fetch.max.wait.ms=10 | jq . --color-output"
docker exec kafka ./bin/kafka-console-consumer.sh --bootstrap-server=kafka:9092 --topic=debezium_binlog --consumer-property fetch.max.wait.ms=10 | jq . --color-output
