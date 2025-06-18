# kubectl exec -it minio-0 -- bash
bash-5.1# mc alias set minio http://minio-service:9000 minio minio123

Added `minio` successfully.

# mc ls minio

mc mb minio/kafka
mc mb minio/hive

Bucket created successfully `minio/kafka`.
Bucket created successfully `minio/hive`.

bash-5.1# mc ls minio
[2025-04-27 09:47:07 UTC]     0B hive/
[2025-04-27 09:47:06 UTC]     0B kafka/

bash-5.1# mc mb minio/hive/warehouse
Bucket created successfully `minio/hive/warehouse`.

bash-5.1# mc ls minio/hive/warehouse
[2025-04-27 09:48:06 UTC]     0B STANDARD /
