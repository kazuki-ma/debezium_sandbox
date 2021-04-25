debezium-example-sandbox
====

docker-compse file for try to use debezium.

How to use
===

Start mysqk, kafka, and debezium on kafka-connect
---

```
make run
```

Setup debezium configuration
---
```
./setup_debezium.sh
```

Start checking mysql binlog
---
```
./show_mysqlbinlog.sh
mysqlbinlog --host=localhost --port=3306 --protocol=TCP -R --user=root --stop-never -vv $LOG_FILE_NAME
```

Start checking debezium output via kafka
---
```
./show_debezium.sh
docker exec kafka ./bin/kafka-console-consumer.sh --bootstrap-server=localhost:9092 --topic=debezium_binlog | jq . --color-output
```

Enter mysql and insert value
---
```
./enter_mysql.sh

mysql> SHOW CREATE TABLE time_test \G
*************************** 1. row ***************************
       Table: time_test
Create Table: CREATE TABLE `time_test` (
  `test_id` bigint NOT NULL AUTO_INCREMENT,
  `value` json NOT NULL DEFAULT (_latin1'{}'),
  `created_sec` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_sec` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_milli` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_milli` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `created_micro` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_micro` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`test_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
1 row in set (0.00 sec)

mysql> INSERT INTO time_test() VALUES ();
Query OK, 1 row affected (0.00 sec)
```

In `./show_mysqlbinlog.sh`, we would see the following output

```
# at 35836
#210426  7:17:35 server id 1  end_log_pos 35915 CRC32 0x8a15a902 	Anonymous_GTID	last_committed=78	sequence_number=79	rbr_only=yes	original_committed_timestamp=1619389055736679	immediate_commit_timestamp=1619389055736679	transaction_length=426
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
# original_commit_timestamp=1619389055736679 (2021-04-26 07:17:35.736679 JST)
# immediate_commit_timestamp=1619389055736679 (2021-04-26 07:17:35.736679 JST)
/*!80001 SET @@session.original_commit_timestamp=1619389055736679*//*!*/;
/*!80014 SET @@session.original_server_version=80023*//*!*/;
/*!80014 SET @@session.immediate_server_version=80023*//*!*/;
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 35915
#210426  7:17:35 server id 1  end_log_pos 36011 CRC32 0xf8bb6425 	Query	thread_id=43	exec_time=0	error_code=0
SET TIMESTAMP=1619389055.735489/*!*/;
BEGIN
/*!*/;
# at 36011
#210426  7:17:35 server id 1  end_log_pos 36064 CRC32 0x38f4c1be 	Rows_query
# insert into time_test() VALUES ()
# at 36064
#210426  7:17:35 server id 1  end_log_pos 36138 CRC32 0x772d6daa 	Table_map: `debezium_test`.`time_test` mapped to number 96
# at 36138
#210426  7:17:35 server id 1  end_log_pos 36231 CRC32 0xd4da91ec 	Write_rows: table id 96 flags: STMT_END_F

BINLOG '
f+qFYB0BAAAANQAAAOCMAACAAB1pbnNlcnQgaW50byB0ZXN0MygpIFZBTFVFUyAoKb7B9Dg=
f+qFYBMBAAAASgAAACqNAAAAAGAAAAAAAAEADWRlYmV6aXVtX3Rlc3QABXRlc3QzAAgI9RISEhIS
EgcEAAADAwYGAAEBAKptLXc=
f+qFYB4BAAAAXQAAAIeNAAAAAGAAAAAAAAEAAgAI/wAUAAAAAAAAAAUAAAAAAAAEAJmpc2Rjmalz
ZGOZqXNkYxy2malzZGMctpmpc2RjCzkBmalzZGMLOQHskdrU
'/*!*/;
### INSERT INTO `debezium_test`.`time_test`
### SET
###   @1=20 /* LONGINT meta=0 nullable=0 is_null=0 */
###   @2='{}' /* JSON meta=4 nullable=0 is_null=0 */
###   @3='2021-04-25 22:17:35' /* DATETIME(0) meta=0 nullable=0 is_null=0 */
###   @4='2021-04-25 22:17:35' /* DATETIME(0) meta=0 nullable=0 is_null=0 */
###   @5='2021-04-25 22:17:35.735' /* DATETIME(3) meta=3 nullable=0 is_null=0 */
###   @6='2021-04-25 22:17:35.735' /* DATETIME(3) meta=3 nullable=0 is_null=0 */
###   @7='2021-04-25 22:17:35.735489' /* DATETIME(6) meta=6 nullable=0 is_null=0 */
###   @8='2021-04-25 22:17:35.735489' /* DATETIME(6) meta=6 nullable=0 is_null=0 */
# at 36231
#210426  7:17:35 server id 1  end_log_pos 36262 CRC32 0x93002df1 	Xid = 354
COMMIT/*!*/;
```

In `./show_debezium.sh`, we would see the following output

```json
{
  "before": null,
  "after": {
    "test_id": 20,
    "value": "{}",
    "created_sec": 1619389055000,
    "updated_sec": 1619389055000,
    "created_milli": 1619389055735,
    "updated_milli": 1619389055735,
    "created_micro": 1619389055735489,
    "updated_micro": 1619389055735489
  },
  "source": {
    "version": "1.5.0.Final",
    "connector": "mysql",
    "name": "mysql",
    "ts_ms": 1619389055000,
    "snapshot": "false",
    "db": "debezium_test",
    "sequence": null,
    "table": "time_test",
    "server_id": 1,
    "gtid": null,
    "file": "mysql-bin.000004",
    "pos": 36138,
    "row": 0,
    "thread": null,
    "query": "INSERT INTO time_test() VALUES ()"
  },
  "op": "c",
  "ts_ms": 1619389055738,
  "transaction": null
}
```

Configurations
===

mysql
---

* Enabled binlog. (`log-bin`).
    * Set `binlog_format=ROW`. It's default.
    * Set `binlog_row_image=FULL`. It's default.
* Enable logging raw query into binlog. (`binlog_rows_query_log_events=ON`).

### About raw query logging (`binlog_rows_query_log_events=ON`)

If you set `binlog_rows_query_log_events=ON`, you can insert diagnostic context as comment form.

For example, executing following SQL

```sql
mysql> INSERT INTO  /* MDC={userIP:aa.bb.cc.dd, handler=XxxControler#UpdateYYY} */ test3() VALUES ();
```

Leads following debezium output.

```json
{
  "before": null,
  "after": {
    "test_id": 38,
    "value": "{}",
    "created_sec": 1619393349000,
    "updated_sec": 1619393349000,
    "created_milli": 1619393349379,
    "updated_milli": 1619393349379,
    "created_micro": 1619393349379038,
    "updated_micro": 1619393349379038
  },
  "source": {
    "version": "1.5.0.Final",
    "connector": "mysql",
    "name": "mysql",
    "ts_ms": 1619393349000,
    "snapshot": "false",
    "db": "debezium_test",
    "sequence": null,
    "table": "test3",
    "server_id": 1,
    "gtid": null,
    "file": "mysql-bin.000006",
    "pos": 3524,
    "row": 0,
    "thread": null,
    "query": "INSERT INTO  /* MDC={userIP:aa.bb.cc.dd, handler=XxxControler#UpdateYYY} */ test3() VALUES ()"
  },
  "op": "c",
  "ts_ms": 1619393349382,
  "transaction": null
}
```

debezium
---

There are nothing special about debezium confiugartion.

### `key.converter.schemas.enable` and `value.converter.schemas.enable`

In this setup, scheme is ignored by `"value.converter.schemas.enable": "false",`.
This configuration is not worked if you don't set converter. Please specify `key.converter` and `key.converter.schemas.enable`, and `values` of it.

```json
{
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "false",
    "value.converter":"org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "false",
}
```

### Put all database messages into one topic.

Once linealizability is broken, it is next to impossible to restore it properly.

In this context, you should maitain linealizability which MySQL's binlog has.

The following settings are required.

* Debezium -> Kafka's Topic distribution: Produce all changes into one topic.
* Kafka's Topic -> Kafka's partition distribution: Set number of partition to `1`.

By those settings, "happened-before" relationship of MySQL user is maintained in consumer side.
