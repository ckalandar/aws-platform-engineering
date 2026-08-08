bucket         = "kk-platform-terraform-state-000000000000"
key            = "dev/terraform.tfstate"
region         = "us-east-1"
#dynamodb_table = "kk-platform-terraform-locks"
encrypt        = false

access_key = "test"
secret_key = "test"
use_lockfile = true
use_path_style              = true
skip_credentials_validation = true
skip_metadata_api_check     = true
skip_region_validation      = true
skip_requesting_account_id  = true

endpoints = {
  dynamodb = "http://localhost:4566"
  s3       = "http://localhost:4566"
  sts      = "http://localhost:4566"
}
