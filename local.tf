locals {
managed_nodes_subnet_ids  = module.vpc.private_subnets
  eks_groups = {
    admins     = "system:masters"
    developers = "nccf-developers"
    viewers    = "nccf-readonly"
  }

  cluster_addons = {
    coredns = {
      addon_version     = "v1.11.1-eksbuild.9"
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      addon_version     = "v1.29.3-eksbuild.5"
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      addon_version     = "v1.18.2-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      addon_version            = "v1.31.0-eksbuild.1"
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.ebs_csi_irsa.iam_role_arn
    }
  }

  k8s_service_accounts_configs = merge({
    loadbalancer_sa = {
      name      = "${module.eks.cluster_id}-loadbalancer-sa"
      role_arn  = module.loadbalancer_irsa.iam_role_arn,
      namespace = "kube-system"
    }
    karpenter = {
      name      = "karpenter"
      role_arn  = module.karpenter_irsa.iam_role_arn,
      namespace = "kube-system"
    }

    external_secrets_sa = {
      name      = "external-secrets-operator-sa"
      role_arn  = module.external_secrets_operator_irsa["external-secrets"].iam_role_arn
      namespace = "elastic"
    }

    efs_sa = {
      name      = "efs-csi-controller-sa"
      role_arn  = module.efs_irsa.iam_role_arn
      namespace = "kube-system"
    }

    keda_sa = {
      name      = "${module.eks.cluster_id}-keda-sa"
      role_arn  = module.keda_irsa.iam_role_arn
      namespace = "keda"
    }
  }, var.extra_service_account_names)

  user_list = flatten([
    for k, v in var.user_list : [
      for user in v : {
        userarn  = user
        username = split("/", user)[1]
        groups   = [local.eks_groups[k]]
      }
    ]
  ])

  role_list = flatten([
    for k, v in var.role_list : [
      for role in v : {
        rolearn  = role
        username = split("/", role)[1]
        groups   = [local.eks_groups[k]]
      }
    ]
  ])

  node_groups_role_name = { for node_key, node_value in module.eks.eks_managed_node_groups :
    "${node_key}" => module.eks.eks_managed_node_groups[node_key].iam_role_name
  }

  node_groups_role_arn = { for node_key, node_value in module.eks.eks_managed_node_groups :
    "${node_key}-role-arn" => module.eks.eks_managed_node_groups[node_key].iam_role_arn
  }

  node_groups_role_list = [for key in keys(local.node_groups_role_arn) :
    local.node_groups_role_arn[key]
  ]

  k8s_service_accounts = { for service_account, service_account_config in local.k8s_service_accounts_configs :
    "${service_account}" => {
      for key, value in service_account_config : key => value
    }
  }

  flat_tags = join(",", [for key, value in var.tags : "${key}=${value}"])

  secrets_internal_manager_secret_stores = var.enable_filebeat || var.enable_metricbeat ? {
    "elastic-creds" = {
      external_secrets_operator_sa              = "external-secrets-operator-sa"
      secretsmanager_secretstore_max_retries    = 1
      secretsmanager_secretstore_namespace      = "elastic"
      secretsmanager_secretstore_region         = "us-east-1"
      secretsmanager_secretstore_retry_interval = "30s"
    }
  } : {}

  secretsmanager_internal_external_secrets_names = var.enable_filebeat || var.enable_metricbeat ? {
    "elastic-credentials" = {
      kubernetes_secretsmanager_secret_name            = "elastic"
      secretsmanager_external_secrets_refresh_interval = "1h"
      secretsmanager_secret_key                        = data.aws_secretsmanager_secret.elasticsearch_credentials[0].arn
      secretsmanager_secretstore_name                  = "elastic-creds"
      secretsmanager_secretstore_namespace             = "elastic"
    }
  } : {}

  kubernetes_namespaces = {
    "keda" = {
      namespace = "keda"
    }
    "elastic" = {
      namespace = "elastic"
    }
  }

  ssm_internal_secrets_secret_stores            = {}
  ssm_internal_parameter_external_secrets_names = {}

  irsa_internal_operators = {
    external-secrets = {
      secrets_ssm_parameter_arns          = ["arn:aws:ssm:*:*:parameter/*"]
      secrets_manager_arns                = ["arn:aws:secretsmanager:*:*:secret:*"]
      external_secrets_operator_namespace = "elastic"
      external_secrets_operator_sa        = "external-secrets-operator-sa"
    }
  }
}