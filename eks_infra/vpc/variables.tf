variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "project" {
  description = "Name of the project to be used as identifier."
  type = string
  default = "Terraform-EKS-AWS"
}

variable "AZs" {
  description = "availability_zones_count"
  type =  number
  default = 2
}