provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.2"

  vpc_id                                = module.vpc.vpc_id
  subnet_ids                            = module.vpc.private_subnets
  control_plane_subnet_ids              = module.vpc.intra_subnets
  cluster_name                          = "${var.project}-${var.environment}-${var.eks_cluster_name}"
  cluster_version                       = var.eks_cluster_version
  cluster_endpoint_private_access       = var.eks_cluster_is_private
  cluster_endpoint_public_access        = var.eks_cluster_is_public
  cluster_endpoint_public_access_cidrs  = var.cluster_endpoint_public_access_cidrs
  cluster_additional_security_group_ids = [aws_security_group.eks_security_group.id]
  cluster_encryption_policy_name        = "${var.project}-${var.environment}-${var.eks_cluster_name}-cluster-encryption-policy"
  cluster_encryption_policy_path        = "/${var.project}-${var.environment}-${var.eks_cluster_name}-eks/"
  cluster_iam_role_dns_suffix           = var.eks_cluster_dns_suffix
  cluster_security_group_name           = "${var.project}-${var.environment}-${var.eks_cluster_name}-eks-security-group"
  iam_role_name                         = "${var.project}-${var.environment}-${var.eks_cluster_name}-role"
  enable_irsa                           = var.enable_irsa
  manage_aws_auth_configmap             = var.manage_aws_auth_config
  aws_auth_users                        = local.user_list
  aws_auth_roles                        = local.role_list
  tags                                  = var.tags

  ###### Update permissions for the aws-auth for nodes #######
  # aws_auth_node_iam_role_arns_non_windows = [
  #   module.eks.eks_managed_node_groups.cluster_mgr.iam_role_arn
  # ]
  ###### Cluster Add-ons for EKS cluster ######
  cluster_addons = local.cluster_addons

  #### Default node group configurations and node groups ####
  iam_role_additional_policies = var.eks_additional_policies

  eks_managed_node_group_defaults = {
    iam_role_additional_policies = var.eks_additional_policies
    iam_role_attach_cni_policy = true
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = "${var.project}-${var.environment}-${var.eks_cluster_name}"
  }
  eks_managed_node_groups = {
    "cluster_mgr" = {
      min_size     = var.managed_nodes_min_size
      max_size     = var.managed_nodes_max_size
      desired_size = var.managed_nodes_desired_size

      # ami_id     = data.aws_ami.eks_default.image_id
      subnet_ids = module.vpc.private_subnets

      # http_put_response_hop_limit = var.http_put_response_hop_limit
      instance_types              = var.managed_nodes_instance_types
      capacity_type               = "ON_DEMAND"
      vpc_security_group_ids      = [aws_security_group.eks_security_group.id]
      # enable_bootstrap_user_data  = true
      # create_launch_template      = true
      # create_security_group       = false
      # create                      = true
      # create_role                 = true
      # launch_template_name        = "${var.project}-${var.environment}-${var.eks_cluster_name}-lt"
      tags = merge(var.tags, {
        Name = "${var.project}-${var.environment}-${var.eks_cluster_name}-mgr"
      })
      # metadata_options = {
      #   "http_put_response_hop_limit" : var.http_put_response_hop_limit
      #   "http_endpoint" : var.http_endpoint
      #   "http_tokens" : var.http_tokens
      # }
      # block_device_mappings = {
      #   "boot_disk" : {
      #     "device_name" : "/dev/xvda",
      #     "ebs" : {
      #       "delete_on_termination" : true,
      #       "volume_size" : var.managed_nodes_disk_space,
      #       "volume_type" : var.managed_nodes_disk_type
      #     }
      #   }
      # }
      force_update_version = true
    }
  }
}
