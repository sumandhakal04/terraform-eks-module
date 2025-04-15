module "vpc_example" {
  source                 = "./modules/vpc"
  project                = var.project
  environment            = var.environment
  aws_availability_zones = data.aws_availability_zones.available.names
  vpc_cidr               = var.vpc_cidr
  private_subnets        = var.private_subnets
  public_subnets         = var.public_subnets
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  enable_dns_hostnames   = var.enable_dns_hostnames

  tags = data.aws_default_tags.default_global_tags.tags
}

module "eks" {
  source                                   = "./modules/eks"
  cluster_name                             = "${var.project}-cluster-${var.environment}"
  max_instance_count                       = var.max_instance_count
  min_instance_count                       = var.min_instance_count
  desired_instance_count                   = var.desired_instance_count
  instance_type                            = var.instance_type
  cluster_version                          = var.cluster_version
  vpc_id                                   = module.vpc_example.vpc_id
  private_subnets                          = module.vpc_example.private_subnets
  eks_managed_node_group_defaults_ami_type = var.eks_managed_node_group_defaults_ami_type
  account_id                               = data.aws_caller_identity.current.account_id
  project                                  = var.project
  environment                              = var.environment
  node_name                                = var.node_name
  kms_key_arn                              = aws_kms_alias.kms_alias_eks.arn

  tags = data.aws_default_tags.default_global_tags.tags
}

module "container-registry" {

  source = "./modules/ecr"

  count           = length(var.registry_name)
  name            = var.registry_name[count.index]
  timeouts_delete = var.timeouts_delete
  force_delete    = var.force_delete
  encryption_type = var.encryption_type
  account_id      = data.aws_caller_identity.current.account_id

  tags = {
    Environment = var.environment
    Terraform   = true
  }
}