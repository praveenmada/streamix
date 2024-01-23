# Terraform Provider Configuration
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Create Namespace
resource "kubernetes_namespace" "trino" {
  metadata {
    name = var.namespace
  }
}

# Create Kafka ConfigMap
resource "kubernetes_config_map" "trino_kafka_config" {
  metadata {
    name      = "trino-kafka-config"
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

# Deploy Trino using Helm Chart
resource "helm_release" "trino" {
  name       = "trino"
  repository = "https://trinodb.github.io/charts/"
  chart      = "trino"
  namespace  = var.namespace
  version    = "0.17.0"    # Specified chart version

  values = [yamlencode({
    coordinator = {
      extraVolumes = [{
        name = "kafka-config",
        configMap = {
          name = kubernetes_config_map.trino_kafka_config.metadata[0].name,
          items = [{
            key = "kafka.properties",
            path = "kafka.properties"
          }]
        }
      }],
      extraVolumeMounts = [{
        name = "kafka-config",
        mountPath = "/etc/trino/catalog/kafka.properties",
        subPath = "kafka.properties",
        readOnly = true
      }]
    }
  })]
}
