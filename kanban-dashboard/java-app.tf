resource "kubernetes_service" "java" {
  metadata {
    name      = "java-app-service"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    selector = {
      app = "java-app"
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "NodePort"
  }
}


resource "kubernetes_deployment" "java" {
  metadata {
      name = "java-app-deployment"
      namespace = kubernetes_namespace.namespace.metadata.0.name
  }


  spec {
    selector {
      match_labels = {
        app = "java-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "java-app"
        }
      }

      spec {
        container {
          name = "java-app"
          image = "ujdev448/kanban-backend-java-mysql:latest"
          image_pull_policy = "IfNotPresent"

          port {
            name = "http"
            container_port = 8080
          }

          resources {
            limits = {
              cpu = 0.2
              memory = "200Mi"
            }
          }

          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                key = "mysql-user-password"
                name = kubernetes_secret.mysql.metadata.0.name

              }
            }
          }


          env {
            name = "DB_USERNAME"
            value_from {
              config_map_key_ref  {
                key  = "mysql-user-username"
                name = kubernetes_config_map.config_map.metadata.0.name

              }
            }
          }

          env {
            name = "DB_SERVER"
            value_from {
              config_map_key_ref {
                key = "mysql-server"
                name = kubernetes_config_map.config_map.metadata.0.name
              }
            }
          }

          env {
            name = "DB_NAME"
            value_from {
              config_map_key_ref {
                key = "mysql-database-name"
                name = kubernetes_config_map.config_map.metadata.0.name
              }
            }

          }

          env {
            name = "MYSQL_USER"
            value_from {
              config_map_key_ref {
                key = "mysql-user-username"
                name = kubernetes_config_map.config_map.metadata.0.name

              }
            }
          }
        }
        image_pull_secrets {
          name = kubernetes_secret.mysql.metadata.0.name
        }
      }
    }
  }
}