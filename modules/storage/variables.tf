variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique Cloud Storage bucket name"
  type        = string

  validation {
    condition     = length(trimspace(var.bucket_name)) >= 3
    error_message = "bucket_name must contain at least 3 characters."
  }
}

variable "location" {
  description = "Bucket location"
  type        = string
  default     = "europe-west1"
}

variable "storage_class" {
  description = "Default storage class"
  type        = string
  default     = "STANDARD"

  validation {
    condition = contains([
      "STANDARD",
      "NEARLINE",
      "COLDLINE",
      "ARCHIVE"
    ], var.storage_class)

    error_message = "storage_class must be STANDARD, NEARLINE, COLDLINE, or ARCHIVE."
  }
}

variable "versioning_enabled" {
  description = "Whether object versioning is enabled"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Whether Terraform may delete a bucket containing objects"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels applied to the bucket"
  type        = map(string)
  default     = {}
}
variable "lifecycle_delete_age_days" {
  description = "Delete objects after this number of days. Set to null to disable automatic deletion."
  type        = number
  default     = null

  validation {
    condition = (
      var.lifecycle_delete_age_days == null ||
      var.lifecycle_delete_age_days > 0
    )

    error_message = "lifecycle_delete_age_days must be null or greater than zero."
  }
}