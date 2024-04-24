environment                  = "dev"
project                      = "nccf"
task_order                   = "gs-35f-131ca"
fisma_id                     = "book5065"
line_office                  = "nesdis"
program_office               = "40-02"
eks_vpc_id                   = "vpc-04b6aac77f7f96xxx"
eks_subnet_ids               = ["subnet-0adb15c8fd6f69xx", "subnet-0de280b9b5b719a35"]
eks_cluster_name             = ""
eks_cluster_version          = "1.22"
eks_cluster_is_private       = true
eks_cluster_is_public        = false
eks_cluster_dns_suffix       = "amazonaws.com"
enable_irsa                  = true
manage_aws_auth_config       = true
managed_nodes_subnet_ids     = ["subnet-0adb15c8fd6f692xx", "subnet-0dxx80b9b5b719a35"]
managed_nodes_disk_space     = 30
managed_nodes_disk_type      = "gp3"
managed_nodes_min_size       = 2
managed_nodes_max_size       = 3
managed_nodes_desired_size   = 2
managed_nodes_instance_types = ["t3.large"]

########## Cluster Groups ###########

user_list = {
  admins = [
    "arn:aws:iam::70844426xx:user/thomas.foster@book.gov",
    "arn:aws:iam::70844426xx:user/matthew.page@book.gov",
  ],
  developers = [],
  viewers    = []
}

eks_cluster_addons = {
  coredns = {
    addon_version     = "v1.8.7-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  }
  kube-proxy = {
    addon_version     = "v1.22.11-eksbuild.2"
    resolve_conflicts = "OVERWRITE"
  }
  vpc-cni = {
    addon_version     = "v1.12.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  }
  aws-ebs-csi-driver = {
    addon_version     = "v1.11.4-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  }
}

eks_additional_policies = {
  ssm_managed   = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ec2_container = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  auto_scaling  = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}

additional_ips_for_security_groups = [
  "<vpc network>", #vpc network
  "10.0.0.0/8"     #all ips from within the accounts
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
