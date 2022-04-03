#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use remote state to retrieve network data
data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "tf-${var.env}s3-final-project-acs730"      // Bucket from where to GET Terraform State
    key    = "${var.env}/network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}

# # Use remote state to retrieve vpcpeering data
# data "terraform_remote_state" "vpcpeering" { // This is to use Outputs from Remote State
#   backend = "s3"
#   config = {
#     bucket = "peering-acs730-final-project"           // Bucket where to SAVE Terraform State
#     key    = "peering-network/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
#     region = "us-east-1"                         // Region where bucket is created
#   }
# }

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}

# webserver1 EC2 instance
resource "aws_instance" "webserver" {
  count                       = var.ec2_count
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
  security_groups             = [aws_security_group.webserver_sg.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-webserver-${count.index+1}"
    }
  )
}

# Create another EBS volume
resource "aws_ebs_volume" "web_ebs" {
  count             = var.ec2_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  size              = 4
  # size              = 40
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-EBS"
    }
  )
}

# Attach EBS volume
resource "aws_volume_attachment" "ebs_att" {
  count       = var.ec2_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.web_ebs[count.index].id
  # volume_id   = aws_ebs_volume.web_ebs[count.index].id
  instance_id = aws_instance.webserver[count.index].id
}


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("${local.name_prefix}.pub")
}


# Security Group of webserver1
resource "aws_security_group" "webserver_sg" {
  name        = "allow_http_ssh_webserver"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_sg.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_sg.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-webserver1-sg"
    }
  )
}


# Bastion host EC2 instance
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[1]
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-bastion"
    }
  )
}
# Security Group of Bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.my_public_ip}/32", "${var.my_private_ip}/32"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-bastion-sg"
    }
  )
}