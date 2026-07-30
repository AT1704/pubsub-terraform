output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_v2_service.this.name
}

output "service_id" {
  description = "Cloud Run service resource ID"
  value       = google_cloud_run_v2_service.this.id
}

output "service_uri" {
  description = "HTTPS URI of the Cloud Run service"
  value       = google_cloud_run_v2_service.this.uri
}

output "latest_revision" {
  description = "Latest ready Cloud Run revision"
  value       = google_cloud_run_v2_service.this.latest_ready_revision
}