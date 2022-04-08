# Define variable for S3
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}
