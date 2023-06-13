# EKS Cluster Security Group
resource "aws_security_group" "cluster_SG" {
  name        = "${var.project}-cluster_SG"
  description = "Cluster connection with worker nodes"
  vpc_id      = var.vpcID

  tags = {
    Name = "${var.project}-eks_cluster_SG"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  security_group_id        = aws_security_group.cluster_SG.id
  description              = "Allow worker nodes connection"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = ["${var.bastion_id}/32"]
}

resource "aws_security_group_rule" "cluster_outbound" {
  security_group_id        = aws_security_group.cluster_SG.id
  description              = "Allow all outbound traffic"
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
}