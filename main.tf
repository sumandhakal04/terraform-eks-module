module "vpc_agribora" {
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