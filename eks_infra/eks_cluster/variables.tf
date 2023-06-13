variable "vpcID" {
  type = string
}

variable "subnet_ids" {
  type = list
}

variable "cluster_name" {
  type = string
}

variable "bastion_id" {
  type = string
}

variable "project" {
  description = "Name of the project to be used as identifier."
  type = string
  default = "Terraform-EKS-AWS"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "Terraform-EKS-AWS"
    "Owner"       = "Ahmed Zedan"
  }
}