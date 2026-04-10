variable "subnet_ids" {
  description = "DB subnet IDs"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "RDS security group"
  type        = string
}

variable "db_name" {
  default = "appdb"
}

variable "db_username" {
  default = "admin"
}

# variable "db_password" {
#   description = "Database password"
#   sensitive   = true
# }

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "secret_arn" {
  description = "Secrets Manager ARN"
  type        = string
}