variable "cluster_name" {}
variable "oidc_provider_arn" {}
variable "oidc_provider_url" {}
variable "hosted_zone_id" {}
variable "project_name" {}
variable "environment" {}
variable "namespace" {
  default = "kube-system"
}

variable "service_account_name" {
  default = "external-dns"
}
