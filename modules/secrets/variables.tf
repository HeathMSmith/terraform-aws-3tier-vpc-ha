variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "recovery_window_in_days" {
  description = "Number of days Secrets Manager retains the secret after deletion. Set to 0 for immediate deletion."
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days == 0 || (var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30)
    error_message = "recovery_window_in_days must be 0 or between 7 and 30 days."
  }
}
