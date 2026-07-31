terraform {
  backend "gcs" {
    bucket = "ananya-gsk-data-mover-2026-tfstate"
    prefix = "terraform/state"
  }
}