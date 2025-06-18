bash-5.1# mc mb hive/warehouse2/testsc
Bucket created successfully `hive/warehouse2/testsc`.

[trino@trino-statefulset-0 /]$ trino
trino> SHOW CATALOGS;
 Catalog
---------
 hive
 system
(2 rows)

trino> SHOW SCHEMAS FROM hive;
       Schema
--------------------
 default
 information_schema
 sampledb
(3 rows)

trino>
    -> CREATE SCHEMA hive.testsc
    -> WITH (
    ->     location = 's3a://hive/warehouse2/testsc'
    -> );
CREATE SCHEMA

  
 trino> CREATE TABLE IF NOT EXISTS hive.testsc.new_test_users (
    ->   id INT,
    ->   name VARCHAR,
    ->   email VARCHAR
    -> )
    -> WITH (
    ->   format = 'PARQUET'
    -> );
CREATE TABLE


trino>
trino>
    ->   INSERT INTO hive.testsc.new_test_users (id, name, email) VALUES
    -> (1, 'Alice', 'alice@example.com'),
    -> (2, 'Bob', 'bob@example.com');
    ->
INSERT: 2 rows

Query 20250501_162727_00014_cxta3, FINISHED, 1 node
Splits: 35 total, 35 done (100.00%)
2.67 [0 rows, 0B] [0 rows/s, 0B/s]

trino> SELECT * FROM hive.testsc.new_test_users;
 id | name  |       email
----+-------+-------------------
  1 | Alice | alice@example.com
  2 | Bob   | bob@example.com
(2 rows)

Query 20250501_162817_00015_cxta3, FINISHED, 1 node
Splits: 17 total, 17 done (100.00%)
0.64 [2 rows, 942B] [3 rows/s, 1.44KB/s]
 
