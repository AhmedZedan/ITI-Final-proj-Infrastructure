module "cluster_vpc" {
  source = "./vpc"
}

module "bastion" {
  source    = "./bastion_server"
  vpc_id    = module.cluster_vpc.vpc_id
  subnet_id = module.cluster_vpc.pub_sub_id[0]
}

module "eks_cluster" {
  source = "./eks_cluster"
  cluster_name = "${var.project}-cluster"
  vpcID = module.cluster_vpc.vpc_id
  subnet_ids = flatten([ module.cluster_vpc.pub_sub_id , module.cluster_vpc.priv_sub_id ])
  bastion_id = module.bastion.bastion_private_id
}

module "node_group" {
  source = "./node_group"
  node_group_name = "${var.project}-node_group"
  cluster_name = module.eks_cluster.cluster_name
  subnet_ids = module.cluster_vpc.priv_sub_id
}

resource "local_file" "cluster_output" {
    content = <<-EOF
    cluster_name:${module.eks_cluster.cluster_name}
    bastion_public_ip:${module.bastion.bastion_public_id}
    EOF
    filename = "cluster_output.txt"
}