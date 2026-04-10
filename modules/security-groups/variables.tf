variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_port" {
  description = "Port application runs on"
  type        = number
  default     = 80
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}