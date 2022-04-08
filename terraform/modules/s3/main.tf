resource "aws_s3_bucket" "s3" {
  bucket = "tf-${var.env}s3-final-project-acs730"
  #key    = "${var.env}/network/terraform.tfstate"
  #bucket = "tf-prods3-final-project-acs730"
  #region = "us-east-1" 

  tags = {
    Name        = "My bucket"
    Environment = "var.env"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.s3.id
  acl    = "private"

}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true

}