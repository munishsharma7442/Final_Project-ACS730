# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    # "prod"    = "t2.micro"      // for test uncomment
    "staging" = "t3.small"
    "dev"     = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Group_9"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "ACS_Project"
  type        = string
  description = "Name prefix"
}


# Variable to signal the current environment 
variable "env" {
  default     = "staging"
  type        = string
  description = "Deployment Environment"
}

variable "ec2_count" {
  type = number
  default = "3"
}

variable "my_bastion_cidrs" {
  type        = string
  default     = "10.100.0.0/16"
  description = "Public IP of my Cloud 9 station to be opened in bastion ingress"
}

