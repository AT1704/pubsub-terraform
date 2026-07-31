output "service_account_email" {
  description = "Email address of the service account"
  value       = google_service_account.this.email
}

output "service_account_name" {
  description = "Fully qualified service account resource name"
  value       = google_service_account.this.name
}

output "service_account_unique_id" {
  description = "Unique numeric identifier of the service account"
  value       = google_service_account.this.unique_id
}

output "roles" {
  description = "Project-level roles granted to the service account"
  value       = sort(tolist(var.roles))
}