
# Presto with Kafka Integration

## Introduction
This repository provides guidance and resources for setting up and querying Kafka topics using Presto. Presto is a high performance, distributed SQL query engine, and integrating it with Kafka allows for SQL-based querying of real-time streaming data.

## Prerequisites
- A running Kafka cluster with topics containing data.
- A Presto cluster set up and accessible.
- Knowledge of SQL for querying data.

## Configuration
### Setting Up Kafka Connector in Presto
1. **Add Kafka Connector**:
   - In the Presto cluster, add a new catalog for Kafka in the `/presto/etc/catalog` directory.
   - Create a file named `kafka.properties` with the following content:
     ```
     connector.name=kafka
     kafka.table-names=topic1,topic2
     kafka.nodes=kafka-broker1:9092,kafka-broker2:9092
     ```
   - Replace `topic1, topic2` with your Kafka topics and `kafka-broker1:9092, kafka-broker2:9092` with your Kafka brokers.

2. **Restart Presto**:
   - Restart the Presto server to apply these changes.

## Usage
### Accessing Presto CLI
- Access the Presto CLI directly if installed locally or by exec-ing into the Presto coordinator pod in Kubernetes.

### Querying Kafka Topics
1. **List Kafka Tables**:
   ```
   SHOW TABLES FROM kafka.default;
   ```
2. **Query Kafka Topic**:
   ```
   SELECT * FROM kafka.default."your-kafka-topic" LIMIT 10;
   ```

## Troubleshooting
- Verify Kafka topic accessibility and configuration in the `kafka.properties` file.
- Check for network connectivity issues between Presto and Kafka.
- Review Presto server logs for detailed error messages.

## Contributing
Contributions to this project are welcome! Please feel free to submit pull requests or open issues for enhancements or bug fixes.