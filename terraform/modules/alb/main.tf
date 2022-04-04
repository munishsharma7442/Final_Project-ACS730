# Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env }
  )
  name_prefix = "${var.prefix}-${var.env}"
}

# resource "aws_lb" "alb" {
#   name               = "alb-${var.env}"
#   internal           = false
#   ip_address_type    = "ipv4"
#   load_balancer_type = "application"
# # security_groups    = var.aws_security_group
#   subnets            = var.public_subnet_ids[*]

#   #enable_deletion_protection = true

#   # access_logs {
#   #   bucket  = aws_s3_bucket.lb_logs.bucket
#   #   prefix  = "test-lb"
#   #   enabled = true
#   # }

#   tags = merge(local.default_tags,
#     {
#       "Name" = "${local.name_prefix}-ALB"
#     }
#   )
# }

# resource "aws_lb_listener" "alb_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group.arn
#   }
# }

# resource "aws_lb_target_group" "target_group" {
#   name     = "tg-alb-${var.env}"
#   port     = 80
#   protocol = "HTTP"
#   target_type = "instance"
#   vpc_id   = aws_vpc.main.id
# }

# resource "aws_vpc" "main" {
#   cidr_block       = var.vpc_cidr
#   instance_tenancy = "default"
#   tags = merge(
#     local.default_tags, {
#       Name = "${local.name_prefix}-VPC"
#     }
#   )
# }