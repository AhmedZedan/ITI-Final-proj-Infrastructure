variable "filter" {
    type = string
    default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "owner" {
    type = string
    default = "099720109477"
}

variable "vpc_id" {
    type = string
}

variable "subnet_id" {
    type = string
}


variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "key_name" {
    type = string
    default = "zedan"
}

variable "bastion_name" {
  type = string
  default = "bastion_server"
}

variable "project" {
  description = "Name of the project to be used as identifier."
  type = string
  default = "Terraform-EKS-AWS"
}