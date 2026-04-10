variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Private subnets for endpoints"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for endpoints"
  type        = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}