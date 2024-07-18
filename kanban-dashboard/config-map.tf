resource "kubernetes_config_map" "config_map" {
  metadata {
    name = "mysql-config-map"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  data = {
    mysql-server = "mysql-service"
    mysql-database-name = "mysql"
    mysql-user-username = "myuser"
  }
}