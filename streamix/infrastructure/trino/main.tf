# Terraform Provider Configuration
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Deploy Trino using Helm Chart
resource "helm_release" "trino" {
  name       = "trino"
  repository = "https://trinodb.github.io/charts/"
  chart      = "trino"
  namespace  = var.namespace
  version    = "0.17.0"    # Specified chart version

  # Add other configurations as needed
}
