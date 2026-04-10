variable "subnet_ids" {
  description = "Private subnets for EC2"
  type        = list(string)
}

variable "ec2_sg_id" {
  description = "EC2 security group"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}