resource "kubernetes_deployment" "node_app" {
  metadata {
    name      = "node-app"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  depends_on = [null_resource.wait_for_db]

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "node-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "node-app"
        }
      }

      spec {
        container {
          name  = "node-app"
          image = docker_image.node_app.name

          env {
            name = "POSTGRES_DB"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_secret.metadata[0].name
                key  = "POSTGRES_DB"
              }
            }
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_secret.metadata[0].name
                key  = "POSTGRES_USER"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_secret.metadata[0].name
                key  = "POSTGRES_PASSWORD"
              }
            }
          }

          port {
            container_port = 4000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "node_app" {
  metadata {
    name      = "node-app"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = "node-app"
    }

    port {
      port        = 4000
      target_port = 4000
    }

    type = "NodePort"
  }
}
