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

variable "manage_addons" {
  description = "When true, create managed EKS add-ons. Set false for floci/LocalStack where CreateAddon is unsupported."
  type        = bool
  default     = true
}

variable "attach_ebs_csi_policy" {
  description = "When true, attach the AWS-managed AmazonEBSCSIDriverPolicy. Set false for floci/LocalStack where AWS-managed policies may not exist."
  type        = bool
  default     = true
}

variable "cluster_log_types" {
  description = "List of EKS control plane log types to enable. Set to empty list for floci/LocalStack where UpdateClusterConfig is unsupported."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}