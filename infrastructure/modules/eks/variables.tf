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