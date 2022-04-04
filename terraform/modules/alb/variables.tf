# Default tags
variable "default_tags" {
  default = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  description = "Name prefix"
}
# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "VPC to host static web site"
}
# Provision public subnets in custom VPC
variable "public_subnet_ids" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}
# SG 
variable "aws_security_group" {
  type        = string
  description = "SG for ALB"
}