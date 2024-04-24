resource "aws_security_group" "eks_security_group" {
  name        = "${var.project}-${var.environment}-${var.eks_cluster_name}-sg"
  description = "Allows traffic to and from EKS group"
  vpc_id      = var.eks_vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.additional_ips_for_security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-${var.eks_cluster_name}-security-group"
    }
  )
}
