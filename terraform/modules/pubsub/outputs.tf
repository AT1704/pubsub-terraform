output "topic_id" {
  description = "Fully qualified Pub/Sub topic ID"
  value       = google_pubsub_topic.this.id
}

output "topic_name" {
  description = "Pub/Sub topic name"
  value       = google_pubsub_topic.this.name
}

output "subscription_id" {
  description = "Fully qualified Pub/Sub subscription ID"
  value       = google_pubsub_subscription.this.id
}

output "subscription_name" {
  description = "Pub/Sub subscription name"
  value       = google_pubsub_subscription.this.name
}

output "dead_letter_topic_id" {
  description = "Fully qualified dead-letter topic ID."
  value       = google_pubsub_topic.dead_letter.id
}

output "dead_letter_subscription_id" {
  description = "Fully qualified dead-letter subscription ID."
  value       = google_pubsub_subscription.dead_letter.id
}