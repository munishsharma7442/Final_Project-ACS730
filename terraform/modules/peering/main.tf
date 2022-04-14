# Use remote state to retrieve the data
data "terraform_remote_state" "accepter" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "tf-${var.vpc_accepter}s3-final-project-acs730" // Bucket from where to GET Terraform State
    key    = "${var.vpc_accepter}/network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                                     // Region where bucket created
  }
}

# Use remote state to retrieve the data
data "terraform_remote_state" "requester" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "tf-${var.vpc_requester}s3-final-project-acs730" // Bucket from where to GET Terraform State
    key    = "${var.vpc_requester}/network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                                      // Region where bucket created
  }
}

# Set AWS Region
provider "aws" {
  region = "us-east-1"
}

# Create Peering
resource "aws_vpc_peering_connection" "default" {
  peer_owner_id = var.owner_id
  peer_vpc_id   = data.terraform_remote_state.accepter.outputs.vpc_id
  vpc_id        = data.terraform_remote_state.requester.outputs.vpc_id
  auto_accept   = true
}

# Retrieve Route Table Accepter OR (Prod or Staging)
data "aws_route_table" "accepter" {
  subnet_id = data.terraform_remote_state.accepter.outputs.private_subnet_ids[0]
}

# Route Table for Accepter OR (Prod or Staging)
resource "aws_route" "route1" {
  count                     = length(var.vpc_cidr_requester)
  route_table_id            = data.aws_route_table.accepter.id
  destination_cidr_block    = var.vpc_cidr_requester[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}

# Retrieve Route Table Requester OR Dev
data "aws_route_table" "requester" {
  subnet_id = data.terraform_remote_state.requester.outputs.public_subnet_ids[0]
}

# Route Table for Requester OR Dev
resource "aws_route" "route2" {
  count                     = length(var.vpc_cidr_accepter)
  route_table_id            = data.aws_route_table.requester.id
  destination_cidr_block    = var.vpc_cidr_accepter[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}

