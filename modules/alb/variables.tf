variable "public_subnet_ids" {
  description = "Public subnets for ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group for ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for target group"
  type        = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}