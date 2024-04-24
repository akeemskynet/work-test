resource "kubernetes_namespace" "this" {
  for_each = var.kubernetes_namespaces != "" ? merge(local.kubernetes_namespaces, var.kubernetes_namespaces) : null
  metadata {
    name = each.value.namespace
  }
  depends_on = [
    module.eks
  ]
}
