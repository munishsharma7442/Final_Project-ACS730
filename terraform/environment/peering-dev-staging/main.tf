# Peering network DEV env to Staging env
module "peering-dev-staging" {
  source             = "../../modules/peering"
  vpc_accepter       = var.vpc_accepter
  vpc_requester      = var.vpc_requester
  vpc_cidr_requester = var.vpc_cidr_requester
  vpc_cidr_accepter  = var.vpc_cidr_accepter
  owner_id           = var.owner_id
}

