resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "kanban-dashboard-namespace"
  }
}