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


# Deploy Trino using Helm Chart
resource "helm_release" "trino" {
  name       = "trino"
  repository = "https://trinodb.github.io/charts/"
  chart      = "trino"
  namespace  = var.namespace
  version    = "0.17.0"    # Specified chart version

   set {
    name  = "additionalCatalogs.kafka"
    value = <<-EOT
      connector.name=kafka
      kafka.nodes=localhost:9092
      kafka.table-names=streamix
      kafka.hide-internal-columns=false
    EOT
  }
}
