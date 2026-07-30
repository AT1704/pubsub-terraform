module "pubsub_push_invoker_iam" {
  source = "./modules/iam"

  project_id   = var.project_id
  account_id   = "pubsub-push-invoker"
  display_name = "Pub/Sub Push Invoker"
  description  = "Identity used by Pub/Sub to invoke the Data Mover Cloud Run service"

  # No project-level roles are required.
  roles = []
}

resource "google_cloud_run_v2_service_iam_member" "pubsub_push_invoker" {
  project  = var.project_id
  location = var.region
  name     = module.data_mover_cloudrun.service_name

  role = "roles/run.invoker"

  member = "serviceAccount:${module.pubsub_push_invoker_iam.service_account_email}"
}