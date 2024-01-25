
# Kafka on Kubernetes with kcat

## Introduction
This repository contains configuration files and scripts for setting up and managing a Kafka cluster running on Kubernetes. It includes examples of how to use `kcat` (formerly `kafkacat`), a versatile Kafka CLI tool, for interacting with the Kafka cluster.

## Prerequisites
- Access to a Kubernetes cluster (e.g., EKS)
- `kubectl` configured to connect to your Kubernetes cluster
- Kafka and Zookeeper running in the Kubernetes cluster
- `kcat` installed on your local machine

## Setup
1. **Kafka and Zookeeper Deployment**:
   Ensure that Kafka and Zookeeper are deployed in your Kubernetes cluster. Terraform files can be found in the respective broker and zookeeper directories.

2. **Accessing Kafka**:
   - Since Kafka is exposed as a `ClusterIP`, use port forwarding to interact with it from your local machine:
     ```bash
     kubectl port-forward svc/kafka-service 9092:9092 -n kafka
     ```

3. **Creating Topics**:
   - Create a Kafka topic by exec-ing into the Kafka broker pod:
     ```bash
     kubectl exec -it <kafka-broker-pod-name> -n kafka -- /bin/bash
     kafka-topics.sh --create --topic <topic-name> --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
     exit
     ```

## Usage

### Producing Messages
To produce messages to a Kafka topic:
```bash
echo "Hello, Kafka" | kcat -P -b localhost:9092 -t <topic-name>
```

### Consuming Messages
To consume messages from a Kafka topic:
```bash
kcat -C -b localhost:9092 -t <topic-name>
```

## Troubleshooting
If you encounter issues, here are some steps to troubleshoot:
1. **Check Kafka Broker Accessibility**: Ensure port forwarding is active.
2. **Validate Topic Name**: Confirm the topic exists using `kcat -L -b localhost:9092`.
3. **Error Messages**: Look for any error messages in the console or Kafka broker logs.
4. **Network Issues**: Check for any network connectivity issues.
5. **Kafka Version Compatibility**: Ensure `kcat` is compatible with your Kafka broker's version.

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue for any enhancements, bug fixes, or improvements.
