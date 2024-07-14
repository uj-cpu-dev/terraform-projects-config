resource "kubernetes_deployment" "react_app" {
  metadata {
    name      = "react-app"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "react-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "react-app"
        }
      }

      spec {
        container {
          name  = "react-app"
          image = docker_image.react_app.name

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "react_app" {
  metadata {
    name      = "react-app"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = "react-app"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "NodePort"
  }
}
