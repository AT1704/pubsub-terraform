resource "google_pubsub_topic" "this" {
  project = var.project_id
  name    = var.topic_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_pubsub_subscription" "this" {
  project = var.project_id
  name    = var.subscription_name
  topic   = google_pubsub_topic.this.id

  ack_deadline_seconds = var.ack_deadline_seconds

  dynamic "push_config" {
    for_each = var.push_endpoint == null ? [] : [1]

    content {
      push_endpoint = var.push_endpoint

      oidc_token {
        service_account_email = var.push_service_account_email

        audience = (
          var.push_audience != null
          ? var.push_audience
          : var.push_endpoint
        )
      }
    }
  }
}