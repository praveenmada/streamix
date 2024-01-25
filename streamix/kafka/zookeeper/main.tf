# Kubernetes Provider Configuration
# Sets up the Kubernetes provider using the configuration file located at '~/.kube/config'.
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "kafka" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "kubernetes_deployment" "zookeeper" {
  metadata {
    name      = "zookeeper"
    namespace = var.namespace
    labels = {
      app = "zookeeper"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "zookeeper"
      }
    }

    template {
      metadata {
        labels = {
          app = "zookeeper"
        }
      }

      spec {
        container {
          image = "wurstmeister/zookeeper"
          name  = "zookeeper"

          port {
            container_port = 2181
          }

          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}

resource "kubernetes_service" "zookeeper_service" {
  metadata {
    name      = "zookeeper-service"
    namespace = var.namespace
    labels = {
      app = "zookeeper-service"
    }
  }

  spec {
    selector = {
      app = "zookeeper"
    }

    port {
      name        = "zookeeper-port"
      port        = 2181
      node_port   = 30181
      target_port = 2181
    }

    type = "NodePort"
  }
}