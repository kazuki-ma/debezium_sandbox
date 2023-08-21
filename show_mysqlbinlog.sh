#!/bin/zsh

LOG_FILE_NAME=`cd mysql/data/; ls -1t mysql-bin.0* | head -n 1`

echo mysqlbinlog --host=localhost --port=3306 --protocol=TCP -R --user=root --stop-never -vv $LOG_FILE_NAME
docker exec -it mysql mysqlbinlog --host=localhost --port=3306 --protocol=TCP -R --user=root --stop-never -vv $LOG_FILE_NAME
