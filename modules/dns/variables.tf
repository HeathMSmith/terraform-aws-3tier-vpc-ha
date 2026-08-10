variable "domain_name" {
  description = "Fully qualified domain name for the application"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID containing the application domain"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}

variable "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer"
  type        = string
}
