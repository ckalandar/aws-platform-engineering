#resource "random_string" "suffix" {
#  length  = 6
#  special = false
#  upper   = false
#}

data "aws_caller_identity" "current" {}

locals {
  state_bucket_name = var.state_bucket_name != null ? var.state_bucket_name : "kk-platform-terraform-state-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "terraform_state" {
  #bucket = var.state_bucket_name != null ? var.state_bucket_name : "${var.project_name}-terraform-state-${random_string.suffix.result}"
  #bucket = var.state_bucket_name != null ? var.state_bucket_name : "${var.project_name}-terraform-state"
  bucket = local.state_bucket_name

  tags = {
    Name        = var.state_bucket_name != null ? var.state_bucket_name : "${var.project_name}-terraform-state"
    Environment = "bootstrap"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state_public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.lock_table_name != null ? var.lock_table_name : "${var.project_name}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = var.lock_table_name != null ? var.lock_table_name : "${var.project_name}-terraform-locks"
    Environment = "bootstrap"
    ManagedBy   = "terraform"
  }
}
