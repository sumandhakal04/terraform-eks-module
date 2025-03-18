# configure IAM roles and OIDC provider for CSI driver in order to be able to dynamically provision volumes (EBS) and persistent volumes
module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${var.cluster_name}-ebs-csi-controller"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = var.tags
}

# configure IAM roles and OIDC provider for CSI driver in order to be able to dynamically provision volumes (EBS) and persistent volumes
module "secrets_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                                          = "${var.cluster_name}-secrets-csi-controller"
  attach_external_secrets_policy                     = true
  external_secrets_secrets_manager_create_permission = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["agribora:secrets-csi-controller-sa"]
    }
  }

  tags = var.tags
}

