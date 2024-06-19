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
resource "aws_security_group" "bastion_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_instance" "private_instance" {
  ami                         = "ami-0b3aef6bc281a13b2"  # Replace with your preferred AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnets.0
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.key.key_name
  # iam_instance_profile = aws_iam_instance_profile.ec2_eks_access_profile.name
  associate_public_ip_address = false

  tags = {
    Name = "PrivateInstance"
  }
}


resource "aws_ec2_instance_connect_endpoint" "ec2_connection" {
  subnet_id = module.vpc.private_subnets.0
  security_group_ids = [aws_security_group.bastion_sg.id]
  depends_on = [aws_instance.private_instance]
}
# The following resource is responsible for management of proxy connection to ec2 instance
# You should install sshuttle in your local laptop
resource "null_resource" "setup_sshuttle" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<EOT
      fuser -k 8888/tcp
      sleep 5
      nohup aws ec2-instance-connect open-tunnel --instance-id ${aws_instance.private_instance.id} --local-port 8888 > open-tunnel.log 2>&1 &
      sleep 5
      pkill sshuttle
      sshuttle --dns -r ec2-user@127.0.0.1:8888 ${module.vpc.vpc_cidr_block} -D --ssh-cmd 'ssh -i ~/.ssh/id_rsa' 
    EOT

  }

  depends_on = [aws_ec2_instance_connect_endpoint.ec2_connection]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  # version = "18.31.2"

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
  # cluster_iam_role_dns_suffix           = var.eks_cluster_dns_suffix
  cluster_security_group_name           = "${var.project}-${var.environment}-${var.eks_cluster_name}-eks-security-group"
  iam_role_name                         = "${var.project}-${var.environment}-${var.eks_cluster_name}-role"
  enable_irsa                           = var.enable_irsa
  authentication_mode = "API_AND_CONFIG_MAP"
  # enable_cluster_creator_admin_permissions = true
  access_entries = {

    user = {
      kubernetes_groups = []
      principal_arn     = data.aws_caller_identity.current.arn

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }
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
  depends_on = [ null_resource.setup_sshuttle ]
}
