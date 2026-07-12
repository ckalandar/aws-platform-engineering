# Terraform Backend Bootstrap

This directory provisions the foundational AWS resources for Terraform remote state:

- S3 bucket for Terraform state storage
- DynamoDB table for state locking

## Usage

1. Copy terraform.tfvars.example to terraform.tfvars
2. Update the values for your environment
3. Run:

```bash
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```
