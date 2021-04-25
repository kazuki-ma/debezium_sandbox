#!/bin/zsh

# --comments = Always send comments to server.

echo "docker exec -it mysql mysql -u root --comments --database debezium_test"
docker exec -it mysql mysql -u root --comments --database debezium_test
