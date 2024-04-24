variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "eks_vpc_id" {
  type = string
}

variable "eks_subnet_ids" {
  type = list(string)
}

variable "control_plane_subnet_ids" {
  type    = list(string)
  default = []
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "eks_cluster_is_public" {
  type = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
  default = null
}

variable "eks_cluster_is_private" {
  type = bool
}

variable "eks_cluster_dns_suffix" {
  type = string
}

variable "enable_irsa" {
  type = bool
}

variable "manage_aws_auth_config" {
  type    = bool
  default = true
}

variable "user_list" {
  type    = map(any)
  default = {}
}

variable "role_list" {
  type    = map(any)
  default = {}
}

variable "eks_additional_policies" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AutoScalingFullAccess",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
  ]
}

variable "http_put_response_hop_limit" {
  type = number
}

variable "http_endpoint" {
  type = string
}

variable "http_tokens" {
  type = string
}

variable "additional_ips_for_security_groups" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "load_balancer_tags" {
  type    = string
  default = ""
}

variable "managed_nodes_subnet_ids" {
  type = list(string)
}

variable "managed_nodes_disk_space" {
  type = number
}

variable "managed_nodes_disk_type" {
  type = string
}

variable "managed_nodes_min_size" {
  type = number
}

variable "managed_nodes_max_size" {
  type = number
}

variable "managed_nodes_desired_size" {
  type = number
}

variable "managed_nodes_instance_types" {
  type = list(string)
}

variable "karpenter_node_disk_size" {
  type = string
}

variable "karpenter_node_disk_type" {
  type = string
}

variable "karpenter_node_disk_encrypted" {
  type    = bool
  default = false
}

variable "karpenter_node_kms_key_id" {
  type    = string
  default = ""
}

variable "container_runtime" {
  type        = string
  default     = "containerd"
  description = "The container runtime to use for Karpenter nodes. Defaults to containerd. NOTE: dockerd is deprecated and cannot be used with bottlerocket instances or in k8s 1.24+"
  # validation {
  #   condition     = var.container_runtime != "containerd"
  #   error_message = "Must use containerd for instances of k8s 1.24+."
  # }
}

variable "break_glass_key" {
  type    = string
  default = ""
}

variable "cpu_limits" {
  type = string
}

variable "memory_limits" {
  type = string
}

variable "karpenter_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to Karpenter nodes. Defaults to var.tags plus a Name tag and the required karpenter.sh/discovery tag."
}

variable "ami_family" {
  type    = string
  default = "AL2"
}

variable "karpenter_ami_id" {
  type = string
}

variable "eks_ami" {
  type = string
}

# variable "external_secrets_operator_sa" {
#   type    = string
#   default = "external-secrets-operator-sa"
# }

# variable "external_secrets_operator_namespace" {
#   type    = string
#   default = "elastic"
# }

variable "enable_secrets_manager" {
  type    = bool
  default = false
}

variable "enable_ssm_parameter" {
  type    = bool
  default = false
}

#SSMManager
variable "ssm_secrets_secret_stores" {
  type = map(object(
    {
      ssm_parameter_secretstore_namespace      = string
      ssm_parameter_secretstore_max_retries    = number
      ssm_parameter_secretstore_retry_interval = string
      ssm_parameter_secretstore_region         = string
      external_secrets_operator_sa             = string
    }
  ))
}

variable "ssm_parameter_external_secrets_names" {
  type = map(object(
    {
      ssm_parameter_kubernetes_secret_name       = string
      ssm_parameter_secretstore_refresh_interval = string
      ssm_parameter_secretstore_namespace        = string
      ssm_parameter_secretstore_name             = string
      ssm_parameter_secret_key_reference         = string
      ssm_parameter_secret_key_name              = string
    }
  ))
}

# variable "secrets_ssm_parameter_arns" {
#   type    = list(string)
#   default = ["arn:aws:ssm:*:*:parameter/*"]
# }

#SecretsManager
variable "secrets_manager_secret_stores" {
  type = map(object(
    {
      secretsmanager_secretstore_namespace      = string
      secretsmanager_secretstore_max_retries    = number
      secretsmanager_secretstore_retry_interval = string
      secretsmanager_secretstore_region         = string
      external_secrets_operator_sa              = string
    }
  ))
}

variable "secretsmanager_external_secrets_names" {
  type = map(object(
    {
      kubernetes_secretsmanager_secret_name            = string
      secretsmanager_external_secrets_refresh_interval = string
      secretsmanager_secret_key                        = string
      secretsmanager_secretstore_namespace             = string
      secretsmanager_secretstore_name                  = string
    }
  ))
}

# variable "secrets_manager_arns" {
#   type    = list(string)
#   default = ["arn:aws:secretsmanager:*:*:secret:*"]
# }

variable "keda_helm_version" {
  type    = string
  default = "2.10.2"
}

variable "karpenter_helm_version" {
  type    = string
  default = "v0.16.3"
}

variable "loadbalancer_helm_version" {
  type    = string
  default = "v1.4.4"
}

variable "efs_helm_version" {
  type    = string
  default = "v2.3.6"
}

variable "external_secrets_operator_helm_version" {
  type    = string
  default = "v0.7.1"
}

variable "keda_role_policy_arns" {
  type    = map(string)
  default = {}
}

variable "keda_irsa_role_policy_arns" {
  type    = map(string)
  default = {}
}

# variable "scale_target_deployment_name" {
#   type = string
# }

variable "kubernetes_namespaces" {
  type = map(object(
    {
      namespace = string
    }
  ))
  default = {
    "keda" = {
      namespace = "keda"
    }
    "elastic" = {
      namespace = "elastic"
    }
  }
}

variable "create_kms_key" {
  type    = bool
  default = true
}

variable "enable_filebeat" {
  description = "Enable filebeat deployment on the cluster. Variables elastic_ca_certs_secret_name and elastic_credentials_secret_name must be set if enabled"
  type        = bool
  default     = false
}

variable "enable_metricbeat" {
  description = "Enable metricbeat deployment on the cluster. Variables elastic_ca_certs_secret_name and elastic_credentials_secret_name must be set if enabled"
  type        = bool
  default     = false
}

variable "enable_keda_queue_scaled_objects" {
  type    = bool
  default = false
}

variable "enable_efs_driver" {
  type    = bool
  default = false
}

variable "filebeat_version" {
  type    = string
  default = "8.5.1"
}

variable "metricbeat_version" {
  type    = string
  default = "8.5.1"
}

variable "elastic_ca_certs_secret_name" {
  description = "Name of the secrets manager secret containing the private CA cert chain for validation of elasticsearch load balancer certificate"
  type        = string
  default     = null
}

variable "elastic_credentials_secret_name" {
  description = "This is the SecretsManager secret name"
  type        = string
  default     = "ELASTIC_CREDENTIALS"
}

variable "enable_keda_scaled_objects" {
  type    = bool
  default = false
}

variable "enable_kubecost" {
  type    = bool
  default = false
}

variable "kubecost_version" {
  type    = string
  default = "v1.101.3"
}

variable "kube_state_metrics_version" {
  type    = string
  default = "5.5.0"
}

variable "extra_service_account_names" {
  type = map(object({
    name      = string
    role_arn  = string
    namespace = string
  }))
  default = {}
}

variable "irsa_external_operators" {
  type = map(object({
    secrets_ssm_parameter_arns          = list(string)
    secrets_manager_arns                = list(string)
    external_secrets_operator_namespace = string
    external_secrets_operator_sa        = string
  }))
  default = {}
}

variable "keda_queue_scaled_objects" {
  type = map(object({
    scaled_object_queue_triggers_min_count = number
    scaled_object_queue_triggers_max_count = number
    namespace                              = string
    keda_auth_trigger_name                 = string
    keda_scaled_object_queue_url           = string
    keda_scaled_object_queue_length        = string
    keda_scaled_object_queue_aws_region    = string
  }))
  default = {}
}

variable "keda_auth_triggers" {
  type = map(object({
    namespace = string
  }))
  default = {}
}

# variable "efs_file_system_id" {
#   type    = string
#   default = null
# }

# variable "efs_directory_permissions" {
#   type    = string
#   default = "775"
# }

# variable "efs_base_path" {
#   type    = string
#   default = "/shared"
# }
