variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)
}

variable "localstack_endpoint" {
  description = "Endpoint URL for floci/LocalStack AWS service emulation."
  type        = string
  default     = "http://localhost:4566"
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID used by External DNS. Defaults to a deterministic floci placeholder."
  type        = string
  default     = "Z00000000000000000000"
}
