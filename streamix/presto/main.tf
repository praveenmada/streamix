# Kubernetes Provider Configuration
# Sets up the Kubernetes provider using the configuration file located at '~/.kube/config'.
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create Namespace
resource "kubernetes_namespace" "presto" {
  metadata {
    name = var.namespace
  }
}

# Create Kafka ConfigMap
resource "kubernetes_config_map" "presto_kafka_config" {
  metadata {
    name      = "presto-kafka-config"
    namespace = var.namespace
  }

  data = {
    "kafka.properties" = <<EOF
    connector.name=kafka
    kafka.nodes=kafka-broker:9092
    kafka.table-names=streamix
    kafka.hide-internal-columns=false
    EOF
  }
}

# Create Deployment
resource "kubernetes_deployment" "presto_deploy" {
  metadata {
    name      = "presto-deploy"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "presto"
      }
    }

    template {
      metadata {
        labels = {
          app = "presto"
        }
      }

      spec {
        container {
          name  = "presto-coordinator"
          image = "greattenchu/openjdk-presto-k:1.0"

          port {
            container_port = 8080
          }

          image_pull_policy = "Always"
          volume_mount {
            mount_path = "/presto/etc/catalog"
            name       = "kafka-config"
          }
        }

        container {
          name  = "presto-worker"
          image = "greattenchu/openjdk-prestoworker-k:1.0"

          port {
            container_port = 8181
          }

          image_pull_policy = "Always"
          volume_mount {
            mount_path = "/presto/etc/catalog"
            name       = "kafka-config"
          }
        }

        volume {
          name = "kafka-config"
          config_map {
            name = kubernetes_config_map.presto_kafka_config.metadata[0].name
          }
        }
      }
    }
  }
}

# Create Service
resource "kubernetes_service" "presto_cluster" {
  metadata {
    name      = "presto-cluster"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "presto"
    }

    port {
      name        = "p80"
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
      node_port   = 30123
    }

    port {
      name        = "p3306"
      port        = 3306
      target_port = 3306
    }

    type = "NodePort"
  }
}