# UDH Pipeline release

## Setup UDH Pipeline
### This is first-time and only time to setup, do not delete, it will delete all services and pods
```
Check list of contexts and namespaces
kubectl config get-contexts
kubectl  get namespaces
----------------------------------------------------------------------
Set current namespace to udh-pipeline

  $kubectl config set-context --current --namespace=udh-pipeline

  $ kubectl apply -f namespace-datapipeline.yaml
  namespace/datapipeline created
```

## Setup Mount Pointes
### This is first-time and only time to setup, do not delete, it will delete all mount points and data

```
----------------------------------------------------------------------
Set mount points, these are all sharable folders for pods

$ kubectl apply -f airflow-pvc.yaml
$ kubectl apply -f  hive-extra-lib-pvc.yaml
```


## Setup Postgres
### This is common database for superset, airflow

```
----------------------------------------------------------------------
# Progres has to be setup on VM with configs, as below

sanjeev@varaisys-vm1:/etc/postgresql/16/main$ sudo apt install postgres

sanjeev@varaisys-vm1:/etc/postgresql/16/main$ apt list --installed|grep postgres

postgresql-16/noble-updates,noble-security,now 16.8-0ubuntu0.24.04.1 amd64 [installed,automatic]
postgresql-client-16/noble-updates,noble-security,now 16.8-0ubuntu0.24.04.1 amd64 [installed,automatic]
postgresql-client-common/noble-updates,now 257build1.1 all [installed,automatic]
postgresql-common/noble-updates,now 257build1.1 all [installed,automatic]
postgresql-contrib/noble-updates,now 16+257build1.1 all [installed]
postgresql/noble-updates,now 16+257build1.1 all [installed]

## Verify

$ sudo -u postgres psql
psql (16.8 (Ubuntu 16.8-0ubuntu0.24.04.1))
Type "help" for help.

postgres=# \q

 sudo systemctl status postgresql

 ip addr list |grep "inet "
    inet 127.0.0.1/8 scope host lo
    inet 192.168.29.51/24 brd 192.168.29.255 scope global noprefixroute enp1s0

## Verify this file: pg_hba.conf

$ cat pg_hba.conf

# Database administrative login by Unix domain socket

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# Remote external connections (Kubernetes services etc.)
host    all             all             0.0.0.0/0               md5
host    all             all             ::0/0                   md5

# Local Unix socket connections
local   all             postgres                                peer
local   all             all                                     scram-sha-256

# IPv4 localhost (internal connections)
host    all             all             127.0.0.1/32            scram-sha-256

# IPv6 localhost
host    all             all             ::1/128                 scram-sha-256

# Replication connections (use scram-sha-256 internally)
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256

==================================================================================================
## Verify this file:  postgresql.conf

# - Connection Settings -

listen_addresses = '*'                  # Listen either hostname or ip

port = 5432                             # (change requires restart)
max_connections = 100                   # (change requires restart)

# - Authentication -
password_encryption = md5       # scram-sha-256 or md5
==================================================================================================

## Apply postgres
$ kubectl apply -f postgres-final-proxy.yaml

## Superset Database and Schema update
sudo -u postgres psql -f superset-db.sql
./superset-db-check.sh     ## Validate connections

## Airflow Database and Schema update
sudo -u postgres psql -f airflow-db.sql
./airflow-db-check.sh   ## Validate connections

```

## Setup Mysql
### This is required for hive and trino

```
$ kubectl apply -f mysql-final-deploy.yaml
 mysql -u root -prootpassword < hive-mysql-user.sql

 # Verify
 mysql -h mysql -u hive -p'hivepass' metastoredb -e "SELECT 1;"
```
## Setup minio
### This is required for data lake objectsotre, parquest

```
$ kubectl apply -f minio-final1-deploy.yaml

bash-5.1# mc alias set minio http://minio-service:9000 minio minio123
Added `minio` successfully.

mc mb minio/kafka
mc mb minio/hive

Bucket created successfully `minio/kafka`.
Bucket created successfully `minio/hive`.

mc ls minio/

```

## Setup Kafka
### This is ingestion
```
$ kubectl apply -f kafka-final-deploy.yaml
$ kubectl apply -f kafka-ui-deploy.yaml

curl -vs telnet://kafka:9092
```

## Setup FTP
### This is ingestion
```
$ kubectl apply -f vsftpd-final2-deployment.yaml

## Verify
curl ftp://testuser:testpass@10.152.183.133/
curl -T localfile ftp://testuser:testpass@10.152.183.133/  # to transfer local file to ftp
##vsftpd service pvc.yaml added
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ftp-pvc
  namespace: udh-pipeline # Ensure this is the same namespace as your pod
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi  # Adjust size as needed
  storageClassName: longhorn  # Use the correct StorageClass if necessary

```

## Setup Airflow
### This is orchestration
```
$ kubectl apply -f airflow-init.yaml              ## first time database is set and seeting admin pass
$ kubectl apply -f airflow-final1-deploy.yaml     ## after initial setup, this should be used for any updates

## Check in browser

```

## Setup Hive and Trino
### This is A fast, distributed SQL query engine that can query data from various sources, 
```
$ kubectl apply -f hive-final-metastore-mysql-hadoop2.yaml     ## hive metastore
$ kubectl apply -f trino-final-hive-mysql-hadoop2.yaml         ## setup trino

## Check in browser
```

## Setup Superset
### This is for dashboard and reporting
```
$ kubectl apply -f redis-final-deploy.yaml           ## for caching 
$ kubectl apply -f superset-final-deploy.yaml        ## setup trino

## Check in browser
```
## Directory structure


```
udh-pipeline-release
.
├── airflow
│   ├── airflow-final3-deploy.yaml
│   └── airflow-init.yaml
├── edge-node
│   └── nginx4.yaml
├── kafka
│   ├── kafka-final-deploy2.yaml
│   ├── kafka-test.sh
│   ├── kafka-topics.txt
│   └── kafka-ui-deploy.yaml
├── minio
│   ├── minio-buckets.sh
│   ├── minio-credentials.yaml
│   └── minio-final2-deploy.yaml
├── one-time
│   ├── airflow-pvc.yaml
│   ├── hive-extra-lib-pvc.yaml
│   ├── mountpath.txt
│   └── udh-pipeline-namespace.yaml
├── postgres
│   ├── airflow-db-check.sh
│   ├── airflow-db.sql
│   ├── postgres-credentials.yaml
│   ├── postgres-final-proxy.yaml
│   ├── superset-db-check.sh
│   └── superset-db.sql
├── README.md
├── requirments2.txt
├── superset
│   ├── redis-final-deploy.yaml
│   └── superset-final-deploy.yaml
├── trino
│   ├── hive-extra-lib-pvc.yaml
│   ├── hive-final-metastore-mysql-hadoop2.yaml
│   ├── hive-mysql-user.sql
│   ├── mysql-final-deploy.yaml
│   ├── trino-catalog.sh
│   └── trino-final-hive-mysql-hadoop2.yaml
├── vsftpd
│   ├── vsftpd-final2-deployment.yaml
│   └── vsftpd-pvc.yaml
└── zookeeper
    ├── loop-it.sh
    ├── zookeeper-deployment.yaml
    └── zookeeper-test.sh

```
## Check services and pods


```
dev_user@varaisysserver:~/a$ microk8s kubectl get   pod,svc
NAME                                                 READY   STATUS      RESTARTS   AGE
pod/airflow-0                                        2/2     Running     0          6h51m
pod/airflow-db-init-gj2mm                            0/1     Completed   0          4d10h
pod/hive-metastore-976d44c5-z2lk6                    1/1     Running     2          5d
pod/kafka-0                                          1/1     Running     3          8d
pod/kafka-1                                          1/1     Running     2          8d
pod/kafka-2                                          1/1     Running     2          8d
pod/kafka-ui-7d76d76846-9zs4j                        1/1     Running     2          3d22h
pod/minio-0                                          1/1     Running     2          8d
pod/minio-1                                          1/1     Running     2          8d
pod/minio-2                                          1/1     Running     2          8d
pod/minio-3                                          1/1     Running     2          8d
pod/mysql-6c49dfc9d5-trrwp                           1/1     Running     1          5d6h
pod/nginx-access-airflow-superset-77c95d9dc8-8bb94   1/1     Running     2          5d5h
pod/redis-db95f65f8-vx9cw                            1/1     Running     2          7d20h
pod/superset-0                                       1/1     Running     1          8d
pod/trino-5d594c8678-2r2zr                           1/1     Running     2          5d
pod/vsftpd-5fff646bb9-tltjw                          1/1     Running     2          4d

NAME                                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                                                                                                                                                        AGE
service/airflow-web                             NodePort    10.152.183.27    <none>        8080:30088/TCP                                                                                                                                                                                 33h
service/hive-metastore                          ClusterIP   10.152.183.232   <none>        9083/TCP                                                                                                                                                                                       5d
service/kafka                                   NodePort    10.152.183.176   <none>        9092:30092/TCP                                                                                                                                                                                 8d
service/kafka-headless                          ClusterIP   None             <none>        9092/TCP,9093/TCP                                                                                                                                                                              8d
service/kafka-ui                                NodePort    10.152.183.244   <none>        80:30380/TCP                                                                                                                                                                                   3d22h
service/minio-nodeport                          NodePort    10.152.183.226   <none>        9000:31000/TCP,9090:31001/TCP                                                                                                                                                                  3d22h
service/minio-service                           ClusterIP   10.152.183.252   <none>        9000/TCP,9090/TCP                                                                                                                                                                              8d
service/minio-svc                               ClusterIP   None             <none>        9000/TCP                                                                                                                                                                                       8d
service/mysql                                   ClusterIP   10.152.183.52    <none>        3306/TCP                                                                                                                                                                                       5d6h
service/nginx-access-airflow-superset-service   NodePort    10.152.183.38    <none>        80:30025/TCP                                                                                                                                                                                   5d5h
service/postgres-proxy                          ClusterIP   None             <none>        5432/TCP                                                                                                                                                                                       8d
service/redis                                   ClusterIP   10.152.183.70    <none>        6379/TCP                                                                                                                                                                                       7d20h
service/superset                                NodePort    10.152.183.199   <none>        8088:30121/TCP                                                                                                                                                                                 8d
service/trino                                   ClusterIP   10.152.183.49    <none>        8080/TCP                                                                                                                                                                                       5d
service/vsftpd                                  NodePort    10.152.183.133   <none>        21:30021/TCP,21100:30200/TCP,21101:30201/TCP,21102:30202/TCP,21103:30203/TCP,21104:30204/TCP,21105:30205/TCP,21106:30206/TCP,21107:30207/TCP,21108:30208/TCP,21109:30209/TCP,21110:30210/TCP   4d
 
```
## Services


| Service Name                                   | Inside POD             | NodePort Mapping         | Cluster IP        | Internal URL                          | Credentials          |
|------------------------------------------------|---------------------------|---------------------------|-------------------|----------------------------------------|----------------------|
| service/airflow-web                            |                           | 8080:30088/TCP            | 10.152.183.177    | http://192.168.29.186:30088            | admin/admin123       |
| service/kafka                                   | kafka:9092               | 9092:30092/TCP            | 10.152.183.176    | 192.168.29.186:30092                   |                      |
| service/kafka-ui                                |                           | 80:30380/TCP              | 10.152.183.244    | http://192.168.29.186:30380            |                      |
| service/minio-nodeport                          | minio-service:9000       | 9000:31000/TCP,9090:31001/TCP | 10.152.183.226 | http://192.168.29.186:31001            | minio/minio123       |
| service/superset                                |             | 8088:30121/TCP            | 10.152.183.199    | http://192.168.29.186:30121            | admin/adminpass      |
| service/vsftpd                                  | vsftpd:21                | 21:30021/TCP              |                   | ftp://192.168.29.186:30021             | testuser/testpass    |
| service/trino                                   | trino:8080               | 8080/TCP                  |                   |                                        |                      |
| service/postgres-proxy                                | postgres:5432            | 5432/TCP            |      | 192.168.29.51:5432            |       |
| service/mysql                                | mysql:3306            | 3306/TCP            |      |            |       |
 

## Sharable mounts and environment variables

```
- name: PYTHONLIB
  value: /opt/pythonlib
- name: JAVA_HOME
  value: /opt/jdk/openjdk-17
- name: JARLIBS
  value: /opt/extra-lib

volumeMounts:
  - name: dags
    mountPath: /opt/airflow/dags
  - name: logs
    mountPath: /opt/airflow/logs
  - name: jdk
    mountPath: /opt/jdk
  - name: pythonlib
    mountPath: /opt/pythonlib
  - name: config
    mountPath: /opt/airflow/config
  - name: data
    mountPath: /opt/airflow/data
  - name: extra-lib
    mountPath: /opt/extra-lib


in program set
# PYTHONPATH="$PYTHONPATH:$PYTHONLIB"
# JAVA_HOME="/opt/jdk/openjdk-17"
   # https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz


All shareable folders will be accessible in edge nodes

# from edge node we can directly install python libraries
pip install package_name -t $PYTHONPATH --no-user

can directly copy jars in /opt/extra-lib
   # wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.6/hadoop-aws-3.3.6.jar
   # wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar
   # wget https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.5.0/spark-sql-kafka-0-10_2.12-3.5.0.jar

can directly copy airflow dag in /opt/airflow/dags


we have opt folder in release directory which can be copied in

microk8s kubectl cp opt/airflow         airflow-0:opt/airflow
microk8s kubectl cp opt/airflow-plugins airflow-0:opt/airflow-plugins
microk8s kubectl cp opt/jdk             airflow-0:opt/jdk
microk8s kubectl cp opt/extra-lib       airflow-0:opt/extra-lib


```
