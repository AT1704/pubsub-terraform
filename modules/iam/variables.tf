variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "account_id" {
  description = "Service account ID without the domain"
  type        = string

  validation {
    condition = (
      length(var.account_id) >= 6 &&
      length(var.account_id) <= 30
    )

    error_message = "account_id must contain between 6 and 30 characters."
  }
}

variable "display_name" {
  description = "Human-readable service account name"
  type        = string
}

variable "description" {
  description = "Description of the service account"
  type        = string
  default     = null
}

variable "roles" {
  description = "Project-level IAM roles granted to the service account"
  type        = set(string)
  default     = []
}