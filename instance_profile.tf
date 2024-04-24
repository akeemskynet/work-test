
resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${module.eks.cluster_id}"
  role = module.eks.eks_managed_node_groups.cluster_mgr.iam_role_name
}
