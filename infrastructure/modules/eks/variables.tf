variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_app_subnet_ids" {
  type = list(string)
}

variable "eks_node_sg_id" {
  type = string
}

variable "eks_cluster_sg_id" {
  type = string
}

variable "eks_version" {
  type    = string
  default = "1.33"
}

variable "manage_oidc" {
  description = "When true, create the EKS IAM OIDC provider. Set false for floci/LocalStack where CreateOpenIDConnectProvider is unsupported."
  type        = bool
  default     = true
}