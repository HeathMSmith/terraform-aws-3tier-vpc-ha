variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type        = bool
  default     = true
}

variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = false
}

variable "private_subnet_ids" {
  description = "Private app subnet IDs"
  type        = list(string)
}

variable "subnet_count" {
  description = "Number of public and private app subnets to associate with their route tables"
  type        = number
  default     = 3

  validation {
    condition     = var.subnet_count > 0 && floor(var.subnet_count) == var.subnet_count
    error_message = "subnet_count must be a positive whole number."
  }
}
