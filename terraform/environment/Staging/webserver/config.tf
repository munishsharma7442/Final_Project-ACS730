terraform {
  backend "s3" {
    bucket = "tf-stagings3-final-project-acs730"         // Bucket where to SAVE Terraform State
    key    = "staging/webservers/terraform.tfstatee" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                         // Region where bucket is created
  }
}