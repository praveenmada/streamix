# Kubernetes Provider Configuration
# Sets up the Kubernetes provider using the configuration file located at '~/.kube/config'.
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "kafka_broker" {
  metadata {
    name      = "kafka-broker"
    namespace = var.namespace
    labels = {
      app = "kafka-broker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "kafka-broker"
      }
    }

    template {
      metadata {
        labels = {
          app = "kafka-broker"
        }
      }

      spec {
        hostname = "kafka-broker"

        container {
          image = "wurstmeister/kafka"
          name  = "kafka-broker"

          env {
            name  = "KAFKA_BROKER_ID"
            value = "1"
          }

          env {
            name  = "KAFKA_ZOOKEEPER_CONNECT"
            value = var.kafka_zookeeper_connect
          }

          env {
            name  = "KAFKA_LISTENERS"
            value = "PLAINTEXT://:9092"
          }

          env {
            name  = "KAFKA_ADVERTISED_LISTENERS"
            value = "PLAINTEXT://kafka-broker:9092"
          }

          port {
            container_port = 9092
          }

          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}


resource "kubernetes_service" "kafka_service" {
  metadata {
    name      = "kafka-service"
    namespace = var.namespace
    labels = {
      app = "kafka-broker"
    }
  }

  spec {
    selector = {
      app = "kafka-broker"
    }

    port {
      port = 9092
    }
  }
}