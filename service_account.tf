resource "kubernetes_service_account" "this" {
  for_each = local.k8s_service_accounts
  metadata {
    name      = each.value.name
    namespace = each.value.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = each.value.role_arn
    }
  }
  depends_on = [
    module.eks,
    module.loadbalancer_irsa,
    module.efs_irsa,
    module.ebs_csi_irsa,
    helm_release.external_secrets_operator,
    module.karpenter_irsa
  ]
}
