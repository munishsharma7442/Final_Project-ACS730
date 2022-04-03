# Module to deploy basic networking 
module "vpc-staging" {
  source              = "../../../modules/aws_network"
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  private_cidr_blocks = var.private_cidr_blocks
  public_cidr_blocks  = var.public_cidr_blocks
  prefix              = var.prefix
  #  default_tags        = var.default_tags
}