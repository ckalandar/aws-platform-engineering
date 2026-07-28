locals {

  aws_region = "us-east-1"

  common = {
    project_name = var.project_name
    environment  = var.environment
  }

  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}
