## global variables
variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

## vpc
variable "vpc_cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type = bool
}

variable "single_nat_gateway" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

# Kubernetes
variable "cluster_version" {
  type = string
}

variable "min_instance_count" {
  type        = number
  description = "EKS min node count"
}

variable "max_instance_count" {
  type        = number
  description = "EKS max node count"
}

variable "desired_instance_count" {
  type        = number
  description = "EKS desired node count"
}

variable "instance_type" {
  type = string
}

variable "node_name" {
  type = string
}

variable "eks_managed_node_group_defaults_ami_type" {
  type = string
}

