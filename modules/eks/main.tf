module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  tags = var.tags

  eks_managed_node_group_defaults = {
    ami_type = var.eks_managed_node_group_defaults_ami_type
  }

  eks_managed_node_groups = {
    default = {
      min_size       = var.min_instance_count
      max_size       = var.max_instance_count
      desired_size   = var.desired_instance_count
      instance_types = [var.instance_type]
      node_name      = var.node_name
    }
  }

  # External encryption key
  create_kms_key = false

  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = var.kms_key_arn
  }

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = "arn:aws:iam::${var.account_id}:role/${var.cluster_name}-ebs-csi-controller"
    }
  }
}
