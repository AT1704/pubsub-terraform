moved {
  from = google_service_account.data_mover
  to   = module.data_mover_iam.google_service_account.this
}

moved {
  from = google_project_iam_member.data_mover_roles
  to   = module.data_mover_iam.google_project_iam_member.roles
}