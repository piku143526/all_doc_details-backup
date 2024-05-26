
# Deploy a Kafka broker in 2 minutes - Kubernetes 

In this tutorial, we will install kafka and zookeeper in kubernetes, so before we move ahead, you need to know about :  
- [Apache Kafka](https://kafka.apache.org/)
- [Kubernetes](https://kubernetes.io/)
  
Also, you must have access to kubernetes cluster, in this tutorial we will use [KUBERNETES ENGINE](https://cloud.google.com/kubernetes-engine/) in Google Cloud Platform.  

### Connect to kubernetes cluster  
```
gcloud container clusters get-credentials main-clus-kube --zone #ZONE --project #PROJECT_ID
```
To check that we connected successfully, the server version field should contain some info. 
```
kubectl version 
```
### Create services

Download configuration files 
```
git clone https://github.com/garawalid/kafka-cluster-k8s.git
```
Deploy zookeeper service  
```
kubectl create -f zookeeper-service.yaml
```
Deploy kafka service  
```
kubectl create -f kafka-service.yaml
```

### Configure Kafka

We need the ip address of the service `#IP_broker`
```
kubectl describe svc kafka-service | grep LoadBalancer\ Ingress 
```
If there is no output, please wait a while a retry.  

In order to create a topic, we need to add it as environment variable like this `#Topic:partition:replica`.
So, we edit `kafka-deploy.yaml` and change `#IP_Broker` & `#Topic`

### Deployment

Deploy zookeeper

```kubectl create -f zookeeper-deploy.yaml```

Deploy kafka broker 

```kubectl create -f kafka-deploy.yaml```



### Test kafka broker

Download kafka and unzip the file 
```
wget http://mirrors.ircam.fr/pub/apache/kafka/2.0.0/kafka_2.11-2.0.0.tgz
tar -xzvf kafka_2.11-2.0.0.tgz
cd kafka_2.11-2.0.0
```

Start a consumer to receive your data
```
bin/kafka-console-consumer.sh --bootstrap-server #IP_broker:9092 --topic #Topic
```
Send some messages to the broker
```
bin/kafka-console-producer.sh --broker-list #IP_broker:9092 --topic #Topic
Hello world!
```
### Debug: 

we need to know pod's name :
```
kubectl get pods
```
after that replace them with `#kafka-pod` & `#zookeeper-pod` to show logs 
```
kubectl logs #kafka-pod
```
```
kubectl logs #zookeeper-pod
```
