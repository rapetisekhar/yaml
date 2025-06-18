CREATE DATABASE metastoredb;
CREATE USER 'hive'@'%' IDENTIFIED BY 'hivepass';
GRANT ALL PRIVILEGES ON metastoredb.* TO 'hive'@'%';
FLUSH PRIVILEGES;

