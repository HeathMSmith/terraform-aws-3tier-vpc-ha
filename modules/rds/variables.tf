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

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_password" {
  description = "Ephemeral database master password"
  type        = string
  sensitive   = true
  ephemeral   = true
}