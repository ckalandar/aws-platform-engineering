terraform {

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19"
    }
  }
}



provider "aws" {
  region = local.aws_region

  access_key = "test"
  secret_key = "test"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true

  endpoints {
    acm        = var.localstack_endpoint
    dynamodb   = var.localstack_endpoint
    ec2        = var.localstack_endpoint
    ecr        = var.localstack_endpoint
    eks        = var.localstack_endpoint
    iam        = var.localstack_endpoint
    route53    = var.localstack_endpoint
    s3         = var.localstack_endpoint
    s3control  = var.localstack_endpoint
    sts        = var.localstack_endpoint
  }
}
