variable "cluster_name" {}
variable "oidc_provider_arn" {}
variable "oidc_provider_url" {}

variable "project_name" {}
variable "environment" {}

variable "namespace" {
  default = "external-secrets"
}

variable "service_account_name" {
  default = "external-secrets"
}
