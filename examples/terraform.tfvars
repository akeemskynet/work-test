environment                  = "dev"
project                      = "nccf"
task_order                   = "gs-35f-131ca"
vpc_cidr                     = "10.0.0.0/16"
private_subnets_cidr         =  ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets_cidr          =  ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
# eks_vpc_id                   = module.vpc.vpc_cidr
# eks_subnet_ids               = module.vpc.public_subnets_cidr
eks_cluster_name             = "eks"
eks_cluster_version          = "1.29"
eks_cluster_is_private       = true
eks_cluster_is_public        = false
eks_cluster_dns_suffix       = "amazonaws.com"
eks_ami                      = ""
karpenter_ami_id             = ""
enable_irsa                  = true
manage_aws_auth_config       = true
# managed_nodes_subnet_ids     = module.vpc.private_subnets_cidr
managed_nodes_disk_space     = 30
managed_nodes_disk_type      = "gp3"
managed_nodes_min_size       = 2
managed_nodes_max_size       = 3
managed_nodes_desired_size   = 2
managed_nodes_instance_types = ["t3.large"]
cluster_endpoint_public_access_cidrs= ["0.0.0.0/0"]

########## Cluster Groups ###########

user_list = {
  admins = [
    "arn:aws:iam::905418297936:user/thomas.foster@book.gov",
    "arn:aws:iam::905418297936:user/matthew.page@book.gov",
  ],
  developers = [],
  viewers    = []
}

# eks_cluster_addons = {
#   coredns = {
#     addon_version     = "v1.8.7-eksbuild.1"
#     resolve_conflicts = "OVERWRITE"
#   }
#   kube-proxy = {
#     addon_version     = "v1.22.11-eksbuild.2"
#     resolve_conflicts = "OVERWRITE"
#   }
#   vpc-cni = {
#     addon_version     = "v1.12.0-eksbuild.1"
#     resolve_conflicts = "OVERWRITE"
#   }
#   aws-ebs-csi-driver = {
#     addon_version     = "v1.11.4-eksbuild.1"
#     resolve_conflicts = "OVERWRITE"
#   }
# }

# eks_additional_policies = {
#      a="arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
#      b="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
#     c="arn:aws:iam::aws:policy/AutoScalingFullAccess",
#      d="arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess",
#      e="arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
#      f="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
#   }

additional_ips_for_security_groups = [
  "10.0.0.0/16"     #all ips from within the accounts
]

tags = {
  "book:programoffice" = "40-02"
  "book:environment"   = "dev"
  "book:lineoffice"    = "nesdis"
  "book:fismaid"       = "book5065"
  "book:taskorder"     = "gs-35f-131ca"
  "book:projectid"     = "nccf"
  "nesdis:poc"         = "ed.ladd@book.gov"
}

karpenter_node_disk_size = "40G"
karpenter_node_disk_type = "gp3"
cpu_limits               = "50mi"
memory_limits               = "256Mi"
http_put_response_hop_limit = 10
http_tokens                 ="optional"
http_endpoint               ="disabled"