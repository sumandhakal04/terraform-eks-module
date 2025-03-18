
variable "project" {
  type        = string
  description = "EKS Target project"
}

variable "environment" {
  type = string
}

variable "account_id" {
  type        = number
  description = "Current account id"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

variable "node_name" {
  type        = string
  description = "EKS Cluster's node names"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version"
}

variable "instance_type" {
  type        = string
  description = "EKS node instance type"
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

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "eks_managed_node_group_defaults_ami_type" {
  type    = string
  default = "AL2_x86_64"
}

variable "tags" {
  type = map(string)
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws_auth_roles configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key used to encrypt resources"
  default     = "value"
}
