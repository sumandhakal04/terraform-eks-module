output "region" {
  description = "AWS region"
  value       = var.region
}

output "secrets_csi_irsa_role_arn" {
  value = module.eks.secrets_csi_irsa_role_arn
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  value = module.eks.cluster_name
}
