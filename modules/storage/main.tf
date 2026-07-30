resource "google_storage_bucket" "this" {
  project       = var.project_id
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  labels = var.labels

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_delete_age_days == null ? [] : [1]

    content {
      action {
        type = "Delete"
      }

      condition {
        age        = var.lifecycle_delete_age_days
        with_state = "LIVE"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}