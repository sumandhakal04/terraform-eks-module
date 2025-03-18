output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "secrets_csi_irsa_role_arn" {
  value = module.secrets_csi_irsa_role.iam_role_arn
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}