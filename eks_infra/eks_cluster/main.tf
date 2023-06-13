# EKS Cluster
resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.27"

  vpc_config {
    security_group_ids      = [aws_security_group.cluster_SG.id]
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  tags = merge(
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}