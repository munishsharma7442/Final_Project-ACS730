# S3 Bucket for Terraform state Peering DEV-PROD
terraform {
  backend "s3" {
    bucket = "peering-acs730-final-project"               // Bucket where to SAVE Terraform State
    key    = "peering-dev-prod/network/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                                  // Region where bucket is created
  }
}