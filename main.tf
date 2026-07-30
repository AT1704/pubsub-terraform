module "pubsub" {
  source = "./modules/pubsub"

  project_id           = var.project_id
  topic_name           = local.pubsub_topic_name
  subscription_name    = local.pubsub_subscription_name
  ack_deadline_seconds = 20

  push_endpoint              = module.data_mover_cloudrun.service_uri
  push_service_account_email = module.pubsub_push_invoker_iam.service_account_email
  push_audience              = module.data_mover_cloudrun.service_uri
}

module "raw_data_bucket" {
  source = "./modules/storage"

  project_id  = var.project_id
  bucket_name = "${var.project_id}-raw-events"
  location    = var.region

  storage_class      = "STANDARD"
  versioning_enabled = false
  force_destroy      = false

  lifecycle_delete_age_days = 30

  labels = {
    environment = terraform.workspace
    application = "data-mover"
    data_type   = "raw-events"
    managed_by  = "terraform"
  }
}

module "data_mover_cloudrun" {
  source = "./modules/cloudrun"

  project_id   = var.project_id
  service_name = "data-mover"
  location     = var.region
  ingress      = "INGRESS_TRAFFIC_ALL"

  image = "${module.artifact_registry.repository_uri}/data-mover:v2"

  service_account_email = module.data_mover_iam.service_account_email

  container_port = 8080
  cpu            = "1"
  memory         = "512Mi"

  min_instances   = 0
  max_instances   = 10
  concurrency     = 20
  timeout_seconds = 60

  environment_variables = {
    PROJECT_ID      = var.project_id
    PUBSUB_TOPIC    = local.pubsub_topic_name
    SUBSCRIPTION_ID = local.pubsub_subscription_name
    BUCKET_NAME     = module.raw_data_bucket.bucket_name
    ENVIRONMENT     = terraform.workspace
  }
}

module "artifact_registry" {
  source = "./modules/artifact_registry"

  project_id    = var.project_id
  location      = var.region
  repository_id = "data-mover"

  description = "Docker images for the Data Mover Cloud Run application"

  labels = {
    environment = terraform.workspace
    application = "data-mover"
    managed_by  = "terraform"
  }
}