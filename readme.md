# EKS Terraform Module

This reusable module is used to create EKS Cluster for use within NCCF.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.53.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.8.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.19.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ebs_csi_irsa"></a> [ebs\_csi\_irsa](#module\_ebs\_csi\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.11.1 |
| <a name="module_efs_irsa"></a> [efs\_irsa](#module\_efs\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.11.1 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 18.31.2 |
| <a name="module_external_secrets_operator_irsa"></a> [external\_secrets\_operator\_irsa](#module\_external\_secrets\_operator\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.11.1 |
| <a name="module_karpenter_irsa"></a> [karpenter\_irsa](#module\_karpenter\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.14.4 |
| <a name="module_keda_irsa"></a> [keda\_irsa](#module\_keda\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.11.1 |
| <a name="module_loadbalancer_irsa"></a> [loadbalancer\_irsa](#module\_loadbalancer\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.11.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_security_group.eks_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.aws_elastic_filesystem_driver](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_secrets_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.filebeat](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.keda-release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kube_state_metrics](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kubecost](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metricbeat](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.elasticsearch_ca_certs_external_secret](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_node_template](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_provisioner](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.keda_auth_trigger](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.local_secretsmanager_external_secrets](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.local_secretsmanager_secretstore](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.local_ssm_parameter_external_secrets](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.local_ssm_parameter_secretstore](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.queue_keda_scaled_object](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.secretsmanager_external_secrets](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.secretsmanager_secretstore](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.ssm_parameter_external_secrets](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.ssm_parameter_secretstore](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_cluster_role.nccf-developers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.nccf-developers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.nccf-readonly](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_storage_class.gp3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.elasticsearch_cert_chain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.elasticsearch_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ips_for_security_groups"></a> [additional\_ips\_for\_security\_groups](#input\_additional\_ips\_for\_security\_groups) | n/a | `list(string)` | n/a | yes |
| <a name="input_ami_family"></a> [ami\_family](#input\_ami\_family) | n/a | `string` | `"AL2"` | no |
| <a name="input_break_glass_key"></a> [break\_glass\_key](#input\_break\_glass\_key) | n/a | `string` | `""` | no |
| <a name="input_container_runtime"></a> [container\_runtime](#input\_container\_runtime) | The container runtime to use for Karpenter nodes. Defaults to containerd. NOTE: dockerd is deprecated and cannot be used with bottlerocket instances or in k8s 1.24+ | `string` | `"containerd"` | no |
| <a name="input_cpu_limits"></a> [cpu\_limits](#input\_cpu\_limits) | n/a | `string` | n/a | yes |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | n/a | `bool` | `true` | no |
| <a name="input_efs_helm_version"></a> [efs\_helm\_version](#input\_efs\_helm\_version) | n/a | `string` | `"v2.3.6"` | no |
| <a name="input_eks_additional_policies"></a> [eks\_additional\_policies](#input\_eks\_additional\_policies) | n/a | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",<br>  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",<br>  "arn:aws:iam::aws:policy/AutoScalingFullAccess",<br>  "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"<br>]</pre> | no |
| <a name="input_eks_ami"></a> [eks\_ami](#input\_eks\_ami) | n/a | `string` | n/a | yes |
| <a name="input_eks_cluster_dns_suffix"></a> [eks\_cluster\_dns\_suffix](#input\_eks\_cluster\_dns\_suffix) | n/a | `string` | n/a | yes |
| <a name="input_eks_cluster_is_private"></a> [eks\_cluster\_is\_private](#input\_eks\_cluster\_is\_private) | n/a | `bool` | n/a | yes |
| <a name="input_eks_cluster_is_public"></a> [eks\_cluster\_is\_public](#input\_eks\_cluster\_is\_public) | n/a | `bool` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | n/a | `string` | n/a | yes |
| <a name="input_eks_subnet_ids"></a> [eks\_subnet\_ids](#input\_eks\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_eks_vpc_id"></a> [eks\_vpc\_id](#input\_eks\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_elastic_ca_certs_secret_name"></a> [elastic\_ca\_certs\_secret\_name](#input\_elastic\_ca\_certs\_secret\_name) | Name of the secrets manager secret containing the private CA cert chain for validation of elasticsearch load balancer certificate | `string` | `null` | no |
| <a name="input_elastic_credentials_secret_name"></a> [elastic\_credentials\_secret\_name](#input\_elastic\_credentials\_secret\_name) | This is the SecretsManager secret name | `string` | `"ELASTIC_CREDENTIALS"` | no |
| <a name="input_enable_efs_driver"></a> [enable\_efs\_driver](#input\_enable\_efs\_driver) | n/a | `bool` | `false` | no |
| <a name="input_enable_filebeat"></a> [enable\_filebeat](#input\_enable\_filebeat) | Enable filebeat deployment on the cluster. Variables elastic\_ca\_certs\_secret\_name and elastic\_credentials\_secret\_name must be set if enabled | `bool` | `false` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | n/a | `bool` | n/a | yes |
| <a name="input_enable_keda_queue_scaled_objects"></a> [enable\_keda\_queue\_scaled\_objects](#input\_enable\_keda\_queue\_scaled\_objects) | n/a | `bool` | `false` | no |
| <a name="input_enable_keda_scaled_objects"></a> [enable\_keda\_scaled\_objects](#input\_enable\_keda\_scaled\_objects) | n/a | `bool` | `false` | no |
| <a name="input_enable_kubecost"></a> [enable\_kubecost](#input\_enable\_kubecost) | n/a | `bool` | `false` | no |
| <a name="input_enable_metricbeat"></a> [enable\_metricbeat](#input\_enable\_metricbeat) | Enable metricbeat deployment on the cluster. Variables elastic\_ca\_certs\_secret\_name and elastic\_credentials\_secret\_name must be set if enabled | `bool` | `false` | no |
| <a name="input_enable_secrets_manager"></a> [enable\_secrets\_manager](#input\_enable\_secrets\_manager) | n/a | `bool` | `false` | no |
| <a name="input_enable_ssm_parameter"></a> [enable\_ssm\_parameter](#input\_enable\_ssm\_parameter) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_external_secrets_operator_helm_version"></a> [external\_secrets\_operator\_helm\_version](#input\_external\_secrets\_operator\_helm\_version) | n/a | `string` | `"v0.7.1"` | no |
| <a name="input_extra_service_account_names"></a> [extra\_service\_account\_names](#input\_extra\_service\_account\_names) | n/a | <pre>map(object({<br>    name      = string<br>    role_arn  = string<br>    namespace = string<br>  }))</pre> | `{}` | no |
| <a name="input_filebeat_version"></a> [filebeat\_version](#input\_filebeat\_version) | n/a | `string` | `"8.5.1"` | no |
| <a name="input_http_endpoint"></a> [http\_endpoint](#input\_http\_endpoint) | n/a | `string` | n/a | yes |
| <a name="input_http_put_response_hop_limit"></a> [http\_put\_response\_hop\_limit](#input\_http\_put\_response\_hop\_limit) | n/a | `number` | n/a | yes |
| <a name="input_http_tokens"></a> [http\_tokens](#input\_http\_tokens) | n/a | `string` | n/a | yes |
| <a name="input_irsa_external_operators"></a> [irsa\_external\_operators](#input\_irsa\_external\_operators) | n/a | <pre>map(object({<br>    secrets_ssm_parameter_arns          = list(string)<br>    secrets_manager_arns                = list(string)<br>    external_secrets_operator_namespace = string<br>    external_secrets_operator_sa        = string<br>  }))</pre> | `{}` | no |
| <a name="input_karpenter_ami_id"></a> [karpenter\_ami\_id](#input\_karpenter\_ami\_id) | n/a | `string` | n/a | yes |
| <a name="input_karpenter_helm_version"></a> [karpenter\_helm\_version](#input\_karpenter\_helm\_version) | n/a | `string` | `"v0.16.3"` | no |
| <a name="input_karpenter_node_disk_encrypted"></a> [karpenter\_node\_disk\_encrypted](#input\_karpenter\_node\_disk\_encrypted) | n/a | `bool` | `false` | no |
| <a name="input_karpenter_node_disk_size"></a> [karpenter\_node\_disk\_size](#input\_karpenter\_node\_disk\_size) | n/a | `string` | n/a | yes |
| <a name="input_karpenter_node_disk_type"></a> [karpenter\_node\_disk\_type](#input\_karpenter\_node\_disk\_type) | n/a | `string` | n/a | yes |
| <a name="input_karpenter_node_kms_key_id"></a> [karpenter\_node\_kms\_key\_id](#input\_karpenter\_node\_kms\_key\_id) | n/a | `string` | `""` | no |
| <a name="input_karpenter_tags"></a> [karpenter\_tags](#input\_karpenter\_tags) | Additional tags to apply to Karpenter nodes. Defaults to var.tags plus a Name tag and the required karpenter.sh/discovery tag. | `map(string)` | `{}` | no |
| <a name="input_keda_auth_triggers"></a> [keda\_auth\_triggers](#input\_keda\_auth\_triggers) | n/a | <pre>map(object({<br>    namespace = string<br>  }))</pre> | `{}` | no |
| <a name="input_keda_helm_version"></a> [keda\_helm\_version](#input\_keda\_helm\_version) | n/a | `string` | `"2.10.2"` | no |
| <a name="input_keda_irsa_role_policy_arns"></a> [keda\_irsa\_role\_policy\_arns](#input\_keda\_irsa\_role\_policy\_arns) | n/a | `map(string)` | `{}` | no |
| <a name="input_keda_queue_scaled_objects"></a> [keda\_queue\_scaled\_objects](#input\_keda\_queue\_scaled\_objects) | n/a | <pre>map(object({<br>    scaled_object_queue_triggers_min_count = number<br>    scaled_object_queue_triggers_max_count = number<br>    namespace                              = string<br>    keda_auth_trigger_name                 = string<br>    keda_scaled_object_queue_url           = string<br>    keda_scaled_object_queue_length        = string<br>    keda_scaled_object_queue_aws_region    = string<br>  }))</pre> | `{}` | no |
| <a name="input_keda_role_policy_arns"></a> [keda\_role\_policy\_arns](#input\_keda\_role\_policy\_arns) | n/a | `map(string)` | `{}` | no |
| <a name="input_kube_state_metrics_version"></a> [kube\_state\_metrics\_version](#input\_kube\_state\_metrics\_version) | n/a | `string` | `"5.5.0"` | no |
| <a name="input_kubecost_version"></a> [kubecost\_version](#input\_kubecost\_version) | n/a | `string` | `"v1.101.3"` | no |
| <a name="input_kubernetes_namespaces"></a> [kubernetes\_namespaces](#input\_kubernetes\_namespaces) | n/a | <pre>map(object(<br>    {<br>      namespace = string<br>    }<br>  ))</pre> | <pre>{<br>  "elastic": {<br>    "namespace": "elastic"<br>  },<br>  "keda": {<br>    "namespace": "keda"<br>  }<br>}</pre> | no |
| <a name="input_load_balancer_tags"></a> [load\_balancer\_tags](#input\_load\_balancer\_tags) | n/a | `string` | `""` | no |
| <a name="input_loadbalancer_helm_version"></a> [loadbalancer\_helm\_version](#input\_loadbalancer\_helm\_version) | n/a | `string` | `"v1.4.4"` | no |
| <a name="input_manage_aws_auth_config"></a> [manage\_aws\_auth\_config](#input\_manage\_aws\_auth\_config) | n/a | `bool` | `true` | no |
| <a name="input_managed_nodes_desired_size"></a> [managed\_nodes\_desired\_size](#input\_managed\_nodes\_desired\_size) | n/a | `number` | n/a | yes |
| <a name="input_managed_nodes_disk_space"></a> [managed\_nodes\_disk\_space](#input\_managed\_nodes\_disk\_space) | n/a | `number` | n/a | yes |
| <a name="input_managed_nodes_disk_type"></a> [managed\_nodes\_disk\_type](#input\_managed\_nodes\_disk\_type) | n/a | `string` | n/a | yes |
| <a name="input_managed_nodes_instance_types"></a> [managed\_nodes\_instance\_types](#input\_managed\_nodes\_instance\_types) | n/a | `list(string)` | n/a | yes |
| <a name="input_managed_nodes_max_size"></a> [managed\_nodes\_max\_size](#input\_managed\_nodes\_max\_size) | n/a | `number` | n/a | yes |
| <a name="input_managed_nodes_min_size"></a> [managed\_nodes\_min\_size](#input\_managed\_nodes\_min\_size) | n/a | `number` | n/a | yes |
| <a name="input_managed_nodes_subnet_ids"></a> [managed\_nodes\_subnet\_ids](#input\_managed\_nodes\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_memory_limits"></a> [memory\_limits](#input\_memory\_limits) | n/a | `string` | n/a | yes |
| <a name="input_metricbeat_version"></a> [metricbeat\_version](#input\_metricbeat\_version) | n/a | `string` | `"8.5.1"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_role_list"></a> [role\_list](#input\_role\_list) | n/a | `map(any)` | `{}` | no |
| <a name="input_secrets_manager_secret_stores"></a> [secrets\_manager\_secret\_stores](#input\_secrets\_manager\_secret\_stores) | SecretsManager | <pre>map(object(<br>    {<br>      secretsmanager_secretstore_namespace      = string<br>      secretsmanager_secretstore_max_retries    = number<br>      secretsmanager_secretstore_retry_interval = string<br>      secretsmanager_secretstore_region         = string<br>      external_secrets_operator_sa              = string<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_secretsmanager_external_secrets_names"></a> [secretsmanager\_external\_secrets\_names](#input\_secretsmanager\_external\_secrets\_names) | n/a | <pre>map(object(<br>    {<br>      kubernetes_secretsmanager_secret_name            = string<br>      secretsmanager_external_secrets_refresh_interval = string<br>      secretsmanager_secret_key                        = string<br>      secretsmanager_secretstore_namespace             = string<br>      secretsmanager_secretstore_name                  = string<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_ssm_parameter_external_secrets_names"></a> [ssm\_parameter\_external\_secrets\_names](#input\_ssm\_parameter\_external\_secrets\_names) | n/a | <pre>map(object(<br>    {<br>      ssm_parameter_kubernetes_secret_name       = string<br>      ssm_parameter_secretstore_refresh_interval = string<br>      ssm_parameter_secretstore_namespace        = string<br>      ssm_parameter_secretstore_name             = string<br>      ssm_parameter_secret_key_reference         = string<br>      ssm_parameter_secret_key_name              = string<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_ssm_secrets_secret_stores"></a> [ssm\_secrets\_secret\_stores](#input\_ssm\_secrets\_secret\_stores) | SSMManager | <pre>map(object(<br>    {<br>      ssm_parameter_secretstore_namespace      = string<br>      ssm_parameter_secretstore_max_retries    = number<br>      ssm_parameter_secretstore_retry_interval = string<br>      ssm_parameter_secretstore_region         = string<br>      external_secrets_operator_sa             = string<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_user_list"></a> [user\_list](#input\_user\_list) | n/a | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | Arn of cloudwatch log group created |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of cloudwatch log group created |
| <a name="output_cluster_addons"></a> [cluster\_addons](#output\_cluster\_addons) | Map of attribute maps for all EKS cluster addons enabled |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_cluster_iam_role_arn"></a> [cluster\_iam\_role\_arn](#output\_cluster\_iam\_role\_arn) | IAM role ARN of the EKS cluster |
| <a name="output_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#output\_cluster\_iam\_role\_name) | IAM role name of the EKS cluster |
| <a name="output_cluster_iam_role_unique_id"></a> [cluster\_iam\_role\_unique\_id](#output\_cluster\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
| <a name="output_cluster_identity_providers"></a> [cluster\_identity\_providers](#output\_cluster\_identity\_providers) | Map of attribute maps for all EKS identity providers enabled |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster. Will block on cluster creation until the cluster is really ready |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster for the OpenID Connect identity provider |
| <a name="output_cluster_platform_version"></a> [cluster\_platform\_version](#output\_cluster\_platform\_version) | Platform version for the cluster |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console |
| <a name="output_cluster_security_group_arn"></a> [cluster\_security\_group\_arn](#output\_cluster\_security\_group\_arn) | Amazon Resource Name (ARN) of the cluster security group |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | ID of the cluster security group |
| <a name="output_cluster_status"></a> [cluster\_status](#output\_cluster\_status) | Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED` |
| <a name="output_cluster_tls_certificate_sha1_fingerprint"></a> [cluster\_tls\_certificate\_sha1\_fingerprint](#output\_cluster\_tls\_certificate\_sha1\_fingerprint) | The SHA1 fingerprint of the public key of the cluster's certificate |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The Kubernetes version for the cluster |
| <a name="output_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#output\_eks\_managed\_node\_groups) | Map of attribute maps for all EKS managed node groups created |
| <a name="output_eks_managed_node_groups_autoscaling_group_names"></a> [eks\_managed\_node\_groups\_autoscaling\_group\_names](#output\_eks\_managed\_node\_groups\_autoscaling\_group\_names) | List of the autoscaling group names created by EKS managed node groups |
| <a name="output_fargate_profiles"></a> [fargate\_profiles](#output\_fargate\_profiles) | Map of attribute maps for all EKS Fargate Profiles created |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The Amazon Resource Name (ARN) of the key |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The globally unique identifier for the key |
| <a name="output_kms_key_policy"></a> [kms\_key\_policy](#output\_kms\_key\_policy) | The IAM resource policy set on the key |
| <a name="output_node_security_group_arn"></a> [node\_security\_group\_arn](#output\_node\_security\_group\_arn) | Amazon Resource Name (ARN) of the node shared security group |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | ID of the node shared security group |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | The OpenID Connect identity provider (issuer URL without leading `https://`) |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The ARN of the OIDC Provider if `enable_irsa = true` |
| <a name="output_self_managed_node_groups"></a> [self\_managed\_node\_groups](#output\_self\_managed\_node\_groups) | Map of attribute maps for all self managed node groups created |
| <a name="output_self_managed_node_groups_autoscaling_group_names"></a> [self\_managed\_node\_groups\_autoscaling\_group\_names](#output\_self\_managed\_node\_groups\_autoscaling\_group\_names) | List of the autoscaling group names created by self-managed node groups |
<!-- END_TF_DOCS -->