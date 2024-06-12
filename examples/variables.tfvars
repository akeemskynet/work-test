environment="dev"
vpc_cidr="10.0.1.0/16"
private_subnets_cidr=["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets_cidr=["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
project="eks"
eks_cluster_name="eks"
eks_cluster_version="1.29"
eks_cluster_is_public=true
eks_cluster_is_private=false
enable_irsa=true
http_put_response_hop_limit=
http_endpoint=
http_tokens=
additional_ips_for_security_groups=["0.0.0.0/0"]
tags = {
  "book:programoffice" = "40-02"
  "book:environment"   = "dev"
  "book:lineoffice"    = "nesdis"
  "book:fismaid"       = "book5065"
  "book:taskorder"     = "gs-35f-131ca"
  "book:projectid"     = "nccf"
  "nesdis:poc"         = "ed.ladd@book.gov"
}
managed_nodes_subnet_ids=
managed_nodes_disk_space=
managed_nodes_disk_type=
managed_nodes_min_size=
managed_nodes_max_size=
managed_nodes_desired_size=
managed_nodes_instance_types=
karpenter_node_disk_size=
karpenter_node_disk_type=
cpu_limits=
memory_limits=
karpenter_ami_id=
eks_ami=
ssm_secrets_secret_stores=
ssm_parameter_external_secrets_names=
secrets_manager_secret_stores=
secretsmanager_external_secrets_names=