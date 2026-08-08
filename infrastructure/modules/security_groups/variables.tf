variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "localstack_endpoint" {
  description = "Endpoint URL for floci/LocalStack AWS service emulation. Used for local-exec provisioner to create cross-referencing SG rules."
  type        = string
  default     = "http://localhost:4566"
}