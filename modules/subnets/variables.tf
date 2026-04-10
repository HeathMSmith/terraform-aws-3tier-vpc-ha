variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs"
  type        = list(string)
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}