resource "kubernetes_persistent_volume" "postgres_pv" {
  metadata {
    name = "postgres-pv"
  }

  spec {
    capacity = {
      storage = "5Gi"
    }

    access_modes = ["ReadWriteOnce"]

    persistent_volume_source {
      host_path {
        path = "/mnt/data"
      }
    }
  }
}

# Persistent Volume Claim
resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name      = "postgres-pvc"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres-service"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.postgres.metadata[0].labels.app
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
    labels = {
      app = "postgres"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          image = "postgres:13"
          name  = "postgres"

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_user
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }

          port {
            container_port = 5432
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "postgres-storage"
          }
        }

        volume {
          name = "postgres-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }
}