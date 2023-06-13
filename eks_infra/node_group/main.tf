# EKS Node Groups
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  capacity_type  = "ON_DEMAND"
  instance_types = [var.instance_types]
  
  remote_access {
    ec2_ssh_key = var.ssh_key
  }

  tags = merge(
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}
