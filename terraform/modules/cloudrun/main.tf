resource "google_cloud_run_v2_service" "this" {
  project  = var.project_id
  name     = var.service_name
  location = var.location

  ingress = var.ingress

  deletion_protection = true

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      template[0].labels,
      client,
      client_version,
      scaling
    ]
  }

  template {
    service_account                  = var.service_account_email
    timeout                          = "${var.timeout_seconds}s"
    max_instance_request_concurrency = var.concurrency

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    containers {
      image = var.image

      ports {
        container_port = var.container_port
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      dynamic "env" {
        for_each = var.environment_variables

        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }
}