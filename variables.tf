variable "project_id" {
  description = "Google Cloud project ID"
  type        = string

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "The project_id value must not be empty."
  }
}

variable "region" {
  description = "Default Google Cloud region"
  type        = string
  default     = "europe-west1"

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "The region value must not be empty."
  }
}