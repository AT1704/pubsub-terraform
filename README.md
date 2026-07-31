# 🚀 GCP Event-Driven Data Mover

> **Production-ready event-driven data pipeline built on Google Cloud using Cloud Run, Pub/Sub, Cloud Storage, Terraform and GitHub Actions.**

This project demonstrates how to build a secure, scalable and observable event-driven architecture using Google Cloud Platform. Infrastructure is fully managed through Terraform, application deployments are automated with GitHub Actions, and events are validated using Pub/Sub Schema Registry before reaching the application.

---

## 🏗 Architecture

<p align="center">
  <img src="docs/architecture.png" width="900">
</p>

---

## ✨ Features

- ✅ Event-driven architecture
- ✅ Cloud Run serverless deployment
- ✅ Pub/Sub Push Subscription
- ✅ Pub/Sub Schema Validation (Avro)
- ✅ Dead Letter Queue (DLQ)
- ✅ Cloud Storage event archival
- ✅ Structured JSON logging
- ✅ Cloud Monitoring Dashboard
- ✅ Cloud Logging
- ✅ Modular Terraform
- ✅ Artifact Registry
- ✅ GitHub Actions CI/CD
- ✅ Workload Identity Federation
- ✅ Production-ready IAM configuration

---

# 🛠 Technology Stack

| Category | Technology |
|-----------|------------|
| Language | Python 3.12 |
| Framework | Flask |
| Compute | Cloud Run |
| Messaging | Pub/Sub |
| Schema Registry | Pub/Sub Schema (Avro) |
| Storage | Cloud Storage |
| Infrastructure | Terraform |
| CI/CD | GitHub Actions |
| Container Registry | Artifact Registry |
| Monitoring | Cloud Monitoring |
| Logging | Cloud Logging |

---

# 📂 Repository Structure

```text
.
├── app/
│   ├── main.py
│   ├── logging_config.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── requirements-dev.txt
│
├── terraform/
│   ├── modules/
│   ├── schemas/
│   ├── backend.tf
│   ├── provider.tf
│   ├── versions.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── main.tf
│   └── ...
│
├── docs/
│   ├── architecture.png
│   ├── cloud-run.png
│   ├── dashboard-overview.png
│   ├── dashboard-operations.png
│   ├── github-actions.png
│   ├── logs.png
│   ├── storage.png
│   ├── subscriptions.png
│   └── topics.png
│
├── tests/
│
├── .github/
│   └── workflows/
│
└── README.md
```

---

# ⚙ Architecture Flow

```
Publisher
      │
      ▼
Pub/Sub Topic
      │
      │  Schema Validation (Avro)
      ▼
Push Subscription
      │
      ▼
Cloud Run
      │
      ├── Structured Logging
      ├── Cloud Monitoring
      └── Cloud Storage
```

---

# ☁ Infrastructure

Infrastructure is provisioned entirely using Terraform.

Resources created:

- Cloud Run
- Pub/Sub Topics
- Push Subscription
- Dead Letter Queue
- Pub/Sub Schema Registry
- Cloud Storage Bucket
- Artifact Registry
- IAM Roles
- Service Accounts

---

# 📦 Pub/Sub Schema Validation

This project uses **Google Pub/Sub Schema Registry** with **Apache Avro** to validate every event before it is accepted by the topic.

Benefits:

- Producer-side validation
- Strong event contracts
- Early rejection of malformed events
- Safer event evolution

Example event:

```json
{
  "event_id": "evt-001",
  "event_type": "order.created",
  "event_version": "1.0",
  "occurred_at": "2026-07-31T12:00:00Z",
  "data": {
    "order_id": "1001",
    "customer": "Alice",
    "status": "CREATED"
  }
}
```

Publishing an invalid event results in:

```
INVALID_ARGUMENT:
Message failed schema validation.
```

---

# 📊 Cloud Run

<p align="center">
<img src="docs/cloud-run.png" width="900">
</p>

---

# 📬 Pub/Sub Topics

<p align="center">
<img src="docs/topics.png" width="900">
</p>

---

# 📥 Pub/Sub Subscriptions

<p align="center">
<img src="docs/subscriptions.png" width="900">
</p>

---

# 🗂 Cloud Storage

<p align="center">
<img src="docs/storage.png" width="900">
</p>

---

# 📈 Monitoring Dashboard

## Application Metrics

<p align="center">
<img src="docs/dashboard-overview.png" width="900">
</p>

### Dashboard tracks

- Request Count
- Request Latency
- CPU Utilization
- Memory Utilization
- Pub/Sub Backlog
- Successful Uploads

---

## Operational Metrics

<p align="center">
<img src="docs/dashboard-operations.png" width="900">
</p>

---

# 📝 Structured Logging

<p align="center">
<img src="docs/logs.png" width="900">
</p>

Each processed event emits structured JSON logs including:

- Message ID
- Bucket
- Object Name
- Processing Time
- Payload Size

---

# 🚀 CI/CD Pipeline

<p align="center">
<img src="docs/github-actions.png" width="900">
</p>

GitHub Actions automatically:

- Run Python tests
- Validate Terraform
- Build Docker image
- Push image to Artifact Registry
- Deploy Cloud Run

---

# 🚀 Running the Project

## Infrastructure

```bash
cd terraform

terraform init

terraform validate

terraform plan

terraform apply
```

## Run locally

```bash
cd app

pip install -r requirements.txt

python main.py
```

---

# 🔒 Security

This project follows Google Cloud security best practices.

- Least Privilege IAM
- Dedicated Service Accounts
- Authenticated Pub/Sub Push
- Workload Identity Federation
- Cloud Run IAM Authentication

---

# 📈 Production Features

- Infrastructure as Code
- Modular Terraform
- Event-driven Architecture
- Schema Validation
- Dead Letter Queue
- Retry Policy
- Structured Logging
- Monitoring Dashboard
- Automated CI/CD
- Cloud Run Autoscaling

---

# 🔮 Future Improvements

- BigQuery Sink
- Eventarc Integration
- Dataflow Pipeline
- OpenTelemetry Tracing
- Cloud Armor
- Custom Metrics

---

# 👩‍💻 Author

## Ananya Tiwari

**DevOps Engineer**

Passionate about cloud infrastructure, Infrastructure as Code, CI/CD automation, and production-grade Google Cloud solutions.

---

⭐ If you found this repository useful, consider giving it a star.