variable "cluster_name" {
  type        = string
}

variable "node_group_name" {
  type        = string
}

variable "subnet_ids" {
  type        = list
}

variable "ssh_key" {
  type        = string
  default     = "zedan"
}

variable "instance_types" {
  type        = string
  default     = "t2.medium"
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