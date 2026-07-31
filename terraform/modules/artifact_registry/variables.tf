variable "project_id" {
  description = "Google Cloud project ID"
  type        = string

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty."
  }
}

variable "location" {
  description = "Artifact Registry repository location"
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "repository_id" {
  description = "Artifact Registry repository ID"
  type        = string

  validation {
    condition     = length(trimspace(var.repository_id)) > 0
    error_message = "repository_id must not be empty."
  }
}

variable "description" {
  description = "Artifact Registry repository description"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels applied to the repository"
  type        = map(string)
  default     = {}
}