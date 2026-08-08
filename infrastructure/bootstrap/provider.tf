provider "aws" {
  region = var.aws_region

  access_key = "test"
  secret_key = "test"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true

  endpoints {
    dynamodb   = var.localstack_endpoint
    iam        = var.localstack_endpoint
    s3         = var.localstack_endpoint
    s3control  = var.localstack_endpoint
    sts        = var.localstack_endpoint
  }
}
