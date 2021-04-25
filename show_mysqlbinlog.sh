#!/bin/zsh

LOG_FILE_NAME=`cd mysql/data/; ls -1t mysql-bin.* | head -n 1`

echo mysqlbinlog --host=localhost --port=3306 --protocol=TCP -R --user=root --stop-never -vv $LOG_FILE_NAME
mysqlbinlog --host=localhost --port=3306 --protocol=TCP -R --user=root --stop-never -vv $LOG_FILE_NAME
