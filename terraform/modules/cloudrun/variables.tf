variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string

  validation {
    condition = (
      length(var.service_name) >= 1 &&
      length(var.service_name) <= 49
    )

    error_message = "service_name must contain between 1 and 49 characters."
  }
}

variable "location" {
  description = "Google Cloud region for the Cloud Run service"
  type        = string
}

variable "image" {
  description = "Container image deployed to Cloud Run"
  type        = string
  validation {
    condition     = length(trimspace(var.image)) > 0
    error_message = "image must not be empty."
  }
}

variable "service_account_email" {
  description = "Service account used as the Cloud Run runtime identity"
  type        = string
}

variable "container_port" {
  description = "Port on which the application listens"
  type        = number
  default     = 8080

  validation {
    condition = (
      var.container_port >= 1 &&
      var.container_port <= 65535
    )

    error_message = "container_port must be between 1 and 65535."
  }
}

variable "environment_variables" {
  description = "Non-sensitive environment variables supplied to the container"
  type        = map(string)
  default     = {}
}
variable "cpu" {
  description = "CPU allocated to each Cloud Run instance"
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory allocated to each Cloud Run instance"
  type        = string
  default     = "512Mi"
}
variable "min_instances" {
  description = "Minimum number of Cloud Run instances"
  type        = number
  default     = 0

  validation {
    condition     = var.min_instances >= 0
    error_message = "min_instances must be zero or greater."
  }
}

variable "max_instances" {
  description = "Maximum number of Cloud Run instances"
  type        = number
  default     = 10

  validation {
    condition     = var.max_instances >= 1
    error_message = "max_instances must be at least one."
  }
}

variable "concurrency" {
  description = "Maximum concurrent requests handled by each instance"
  type        = number
  default     = 20

  validation {
    condition = (
      var.concurrency >= 1 &&
      var.concurrency <= 1000
    )

    error_message = "concurrency must be between 1 and 1000."
  }
}

variable "timeout_seconds" {
  description = "Maximum request processing time in seconds"
  type        = number
  default     = 60

  validation {
    condition = (
      var.timeout_seconds >= 1 &&
      var.timeout_seconds <= 3600
    )

    error_message = "timeout_seconds must be between 1 and 3600."
  }
}
variable "ingress" {
  description = "Cloud Run ingress setting"

  type = string

  default = "INGRESS_TRAFFIC_ALL"

  validation {
    condition = contains([
      "INGRESS_TRAFFIC_ALL",
      "INGRESS_TRAFFIC_INTERNAL",
      "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
    ], var.ingress)

    error_message = "Invalid ingress setting."
  }
}


