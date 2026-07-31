variable "topic_name" {
  description = "Name of the Pub/Sub topic"
  type        = string

  validation {
    condition     = length(trimspace(var.topic_name)) > 0
    error_message = "topic_name must not be empty."
  }
}

variable "subscription_name" {
  description = "Name of the Pub/Sub subscription"
  type        = string

  validation {
    condition     = length(trimspace(var.subscription_name)) > 0
    error_message = "subscription_name must not be empty."
  }
}

variable "ack_deadline_seconds" {
  description = "Number of seconds Pub/Sub waits for message acknowledgement"
  type        = number
  default     = 20

  validation {
    condition = (
      var.ack_deadline_seconds >= 10 &&
      var.ack_deadline_seconds <= 600
    )

    error_message = "ack_deadline_seconds must be between 10 and 600 seconds."
  }
}
variable "push_endpoint" {
  description = "HTTPS endpoint to which Pub/Sub pushes messages"
  type        = string
  default     = null
}

variable "push_service_account_email" {
  description = "Service account used to generate the OIDC token"
  type        = string
  default     = null
}

variable "push_audience" {
  description = "Audience claim included in the OIDC token"
  type        = string
  default     = null
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty."
  }
}

variable "dead_letter_topic_name" {
  description = "Name of the Pub/Sub dead-letter topic."
  type        = string
}

variable "max_delivery_attempts" {
  description = "Maximum delivery attempts before forwarding to the dead-letter topic."
  type        = number
  default     = 5

  validation {
    condition = (
      var.max_delivery_attempts >= 5 &&
      var.max_delivery_attempts <= 100
    )
    error_message = "max_delivery_attempts must be between 5 and 100."
  }
}

variable "minimum_backoff" {
  description = "Minimum retry backoff duration."
  type        = string
  default     = "10s"
}

variable "maximum_backoff" {
  description = "Maximum retry backoff duration."
  type        = string
  default     = "60s"
}

variable "dead_letter_subscription_name" {
  description = "Name of the subscription attached to the dead-letter topic."
  type        = string
}