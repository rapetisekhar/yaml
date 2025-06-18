#!/bin/bash

# kafka-test.sh

echo 'Test Kafka'

microk8s kubectl get pods -l app=kafka  -n udh-pipeline
echo 

kafka_list=$(microk8s kubectl get pods -l app=kafka -n udh-pipeline| awk '/kafka/ {print $1}')

echo -ne "\nKafka:"
for kf in $kafka_list;
do
	echo -ne "\n$kf "
	status=$(microk8s kubectl exec -it $kf -- bash -c 'kafka-metadata-quorum.sh --bootstrap-controller localhost:9093 describe --status|grep -i leaderid')
	echo -e "$status"
done
ghHG

# cp kafka-topic-test.sh  kafka-0:/tmp
# microk8s kubectl exec -it kafka-0 -- bash -c '/tmp/kafka-topic-test.sh'

exit
