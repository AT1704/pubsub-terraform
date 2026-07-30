locals {
  data_mover_roles = toset([
    "roles/pubsub.subscriber",
    "roles/storage.objectAdmin",
    "roles/bigquery.dataEditor"
  ])
}

locals {
  pubsub_topic_name        = "orders-topic"
  pubsub_subscription_name = "orders-subscription"

  data_mover_image = format(
    "%s/data-mover:v1",
    module.artifact_registry.repository_uri
  )
}