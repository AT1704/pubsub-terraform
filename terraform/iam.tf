module "data_mover_iam" {
  source = "./modules/iam"

  project_id   = var.project_id
  account_id   = "data-mover"
  display_name = "Data Mover Service Account"
  description  = "Runtime identity used by the Data Mover application"

  roles = local.data_mover_roles
}