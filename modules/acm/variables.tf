variable "domain_name" {
  description = "Fully qualified domain name for the ACM certificate"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID used for DNS certificate validation"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}
