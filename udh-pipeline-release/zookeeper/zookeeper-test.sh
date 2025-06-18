#!/bin/bash

# zookeeper-test.sh

echo 'Test Zookeeper'

microk8s kubectl get pods -l app=zookeeper  -n udh-pipeline
echo 

zookeeper_list=$(microk8s kubectl get pods -l app=zookeeper  -n udh-pipeline| awk '/zookeeper/ {print $1}')

echo -ne "\nZookeeper:"
for zk in $zookeeper_list;
do
	echo -ne "\n$zk"
	#status=$(microk8s kubectl exec -it $zk -- bash -c '/bin/echo srvr | /bin/nc 127.0.0.1 2181')
	status=$(microk8s kubectl exec -it $zk -- bash -c '/bin/echo srvr | /bin/nc 127.0.0.1 2181|grep -i mode')
	echo  $status|cut -d: -f2
done

exit
