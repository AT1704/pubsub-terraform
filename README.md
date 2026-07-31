# GCP Event-Driven Data Mover

## Overview

An event-driven data ingestion service built on Google Cloud using Cloud
Run, Pub/Sub, Cloud Storage, and Terraform. The infrastructure is fully
managed as code and the application is deployed automatically using
GitHub Actions.

## Architecture

-   Cloud Run (Python/Flask)
-   Pub/Sub (Push Subscription)
-   Pub/Sub AVRO Schema Validation
-   Cloud Storage
-   Artifact Registry
-   IAM & Service Accounts
-   GitHub Actions
-   Workload Identity Federation
-   Dead Letter Queue (DLQ)
-   Structured JSON Logging
-   Cloud Monitoring Dashboard

## Repository Structure

``` text
.
├── app/
│   ├── main.py
│   ├── logging_config.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── terraform/
│   ├── backend.tf
│   ├── provider.tf
│   ├── versions.tf
│   ├── variables.tf
│   ├── locals.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── schemas/
│   │   └── order-created.avsc
│   └── modules/
│       ├── artifact_registry/
│       ├── cloudrun/
│       ├── iam/
│       ├── pubsub/
│       └── storage/
│
├── tests/
├── docs/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── deploy.yml
└── README.md
```

## Infrastructure

Infrastructure is provisioned entirely using Terraform.

Resources created: - Cloud Run - Pub/Sub Topics - Push Subscription -
Dead Letter Topic - Dead Letter Subscription - Pub/Sub AVRO Schema -
Cloud Storage Bucket - Artifact Registry - IAM Roles - Service Accounts

## Pub/Sub Schema Validation

The `orders-topic` is configured with an AVRO schema. Messages are
validated at publish time before reaching Cloud Run.

Example valid event:

``` bash
gcloud pubsub topics publish orders-topic \
  --message='{
    "event_id":"evt-123",
    "event_type":"order.created",
    "event_version":"1.0",
    "occurred_at":"2026-07-31T12:00:00Z",
    "data":{
      "order_id":"123",
      "customer":"example-customer",
      "status":"created"
    }
  }'
```

## Testing

``` bash
pytest -v
```

## Deployment

``` bash
cd terraform

terraform init
terraform validate
terraform plan
terraform apply

cd ..
```

The application is deployed automatically by GitHub Actions when changes
are pushed to the `main` branch.

## Security

-   Workload Identity Federation
-   Least-privilege IAM
-   Dedicated service accounts
-   Infrastructure as Code
-   Prevent-destroy lifecycle protection for critical resources
