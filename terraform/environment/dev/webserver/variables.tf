# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "staging" = "t3.small"
    "dev"     = "t3.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

# Cloud9 Public IP
variable "my_public_ip" {
  type        = string
  description = "Public IP of my Cloud9"
  default     = "52.91.88.126"
}

# Cloud9 Private IP
variable "my_private_ip" {
  type        = string
  description = "Private IP of my Cloud9"
  default     = "172.31.84.89"
}
