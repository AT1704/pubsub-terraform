output "repository_id" {
  description = "Artifact Registry repository ID"
  value       = google_artifact_registry_repository.this.repository_id
}

output "repository_name" {
  description = "Fully qualified repository resource name"
  value       = google_artifact_registry_repository.this.name
}

output "repository_uri" {
  description = "Docker repository URI"
  value = format(
    "%s-docker.pkg.dev/%s/%s",
    var.location,
    var.project_id,
    google_artifact_registry_repository.this.repository_id
  )
}