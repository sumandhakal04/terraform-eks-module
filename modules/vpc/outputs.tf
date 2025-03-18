output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "Id of the created VPC"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "private subnets of the created VPC"
}
