output "mysql_service_ip" {
  value = kubernetes_service.mysql.spec[0].cluster_ip
}

output "mysql_service_port" {
  value = kubernetes_service.mysql.spec[0].port[0].port
}

output "java_service_ip" {
  value = kubernetes_service.java.spec[0].cluster_ip
}

output "java_service_port" {
  value = kubernetes_service.java.spec[0].port[0].node_port
}
