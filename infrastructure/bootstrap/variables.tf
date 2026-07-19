variable "aws_region" {
  description = "AWS region for the bootstrap resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for bootstrap resource naming"
  type        = string
  default     = "kk-platform"
}

variable "state_bucket_name" {
  description = "Optional override for the Terraform state bucket name"
  type        = string
  default     = null
}

variable "lock_table_name" {
  description = "Optional override for the Terraform lock table name"
  type        = string
  default     = null
}

variable "manage_oidc" {
  description = "When true, manage the GitHub OIDC provider and role in the current AWS account. Leave false for temporary playground environments that should only bootstrap the backend resources."
  type        = bool
  default     = false
}