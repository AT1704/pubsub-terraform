output "project_id" {
  description = "Google Cloud project ID"
  value       = data.google_project.current.project_id
}

output "project_number" {
  description = "Numeric identifier of the Google Cloud project"
  value       = data.google_project.current.number
}

output "project_name" {
  description = "Display name of the Google Cloud project"
  value       = data.google_project.current.name
}

output "topic_id" {
  description = "Fully qualified Pub/Sub topic ID"
  value       = module.pubsub.topic_id
}

output "subscription_id" {
  description = "Fully qualified Pub/Sub subscription ID"
  value       = module.pubsub.subscription_id
}

output "data_mover_service_account_email" {
  description = "Email address of the Data Mover service account"
  value       = module.data_mover_iam.service_account_email
}

output "data_mover_service_account_unique_id" {
  description = "Unique numeric ID of the Data Mover service account"
  value       = module.data_mover_iam.service_account_unique_id
}

output "data_mover_roles" {
  description = "Project-level roles granted to the Data Mover service account"
  value       = module.data_mover_iam.roles
}
output "raw_data_bucket_name" {
  description = "Name of the raw Data Mover bucket"
  value       = module.raw_data_bucket.bucket_name
}

output "raw_data_bucket_url" {
  description = "URL of the raw Data Mover bucket"
  value       = module.raw_data_bucket.bucket_url
}
output "data_mover_cloudrun_name" {
  description = "Name of the Data Mover Cloud Run service"
  value       = module.data_mover_cloudrun.service_name
}

output "data_mover_cloudrun_uri" {
  description = "URI of the Data Mover Cloud Run service"
  value       = module.data_mover_cloudrun.service_uri
}

output "data_mover_cloudrun_latest_revision" {
  description = "Latest ready revision of the Data Mover Cloud Run service"
  value       = module.data_mover_cloudrun.latest_revision
}


output "pubsub_push_invoker_email" {
  description = "Service account used by Pub/Sub to invoke Cloud Run"
  value       = module.pubsub_push_invoker_iam.service_account_email
}

output "artifact_registry_repository_name" {
  description = "Artifact Registry repository resource name"
  value       = module.artifact_registry.repository_name
}

output "artifact_registry_repository_uri" {
  description = "Docker repository URI"
  value       = module.artifact_registry.repository_uri
}