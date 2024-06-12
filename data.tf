data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
data "aws_secretsmanager_secret" "elasticsearch_credentials" {
  count = var.enable_filebeat || var.enable_metricbeat ? 1 : 0
  name = var.elastic_credentials_secret_name
}

data "aws_secretsmanager_secret" "elasticsearch_cert_chain" {
  count = var.enable_filebeat || var.enable_metricbeat ? 1 : 0
  name = var.elastic_ca_certs_secret_name
} 
data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_cluster_version}-v*"]
  }
}
# data "kubernetes_ingress_v1" "kubecost" {
#   metadata {
#     name      = "kubecost-cost-analyzer"
#     namespace = "kubecost"
#   }

#   depends_on = [
#     helm_release.kubecost
#   ]
# }
