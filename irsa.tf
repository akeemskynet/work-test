module "karpenter_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name                          = "${module.eks.cluster_name}-karpenter-controller"
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_id = module.eks.cluster_name
  karpenter_controller_node_iam_role_arns = [
    module.eks.cluster_iam_role_arn,
    module.eks.eks_managed_node_groups.cluster_mgr.iam_role_arn
  ]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["karpenter:karpenter"]
    }
  }
  depends_on = [
    module.eks
  ]
  tags = var.karpenter_tags

}

module "loadbalancer_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name                              = "${module.eks.cluster_name}-loadbalancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:${module.eks.cluster_name}-loadbalancer-sa"]
    }
  }
  depends_on = [
    module.eks
  ]
  tags = var.tags
}

module "efs_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name             = "${module.eks.cluster_name}-efs-controller"
  attach_efs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
  depends_on = [
    module.eks
  ]
  tags = var.tags
}

module "external_secrets_operator_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  for_each                       = merge(var.irsa_external_operators, local.irsa_internal_operators)
  role_name                      = "${module.eks.cluster_name}-${each.key}-eso-operator"
  attach_external_secrets_policy = true

  external_secrets_ssm_parameter_arns   = each.value.secrets_ssm_parameter_arns
  external_secrets_secrets_manager_arns = each.value.secrets_manager_arns

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${each.value.external_secrets_operator_namespace}:${each.value.external_secrets_operator_sa}"]
    }
  }
  depends_on = [
    module.eks
  ]
  tags = var.tags
}

module "keda_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name = "${module.eks.cluster_name}-keda-controller"

  role_policy_arns = var.keda_irsa_role_policy_arns

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["keda:${module.eks.cluster_name}-keda-sa"]
    }
  }
  depends_on = [
    module.eks
  ]
  tags = var.tags
}

module "ebs_csi_irsa" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "5.28.0"
  role_name = "${module.eks.cluster_name}-ebs-csi-controller"

  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
  tags = var.tags
}
