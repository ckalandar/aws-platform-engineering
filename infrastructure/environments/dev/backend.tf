terraform {
  backend "s3" {
    bucket         = "kk-platform-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "kk-platform-terraform-locks"
    encrypt        = true
  }
}
