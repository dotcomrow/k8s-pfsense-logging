resource "random_id" "suffix_gcp" {
  byte_length = 2
}

resource "google_project" "infra" {
  name       = "PFSense Logging"
  project_id = "pfsense-logging-infra-${random_id.suffix_gcp.hex}"
  org_id     = var.gcp_org_id
}

resource "google_project_service" "logging" {
  project = google_project.infra.project_id
  service = "logging.googleapis.com"
}

resource "google_service_account" "pfsense_logs" {
  account_id   = "pfsense-logs"
  display_name = "Pfsense Log Writer"
  project      = google_project.infra.project_id
}

resource "google_project_iam_member" "log_writer" {
  project = google_project.infra.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.pfsense_logs.email}"
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.pfsense_logs.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

output "gcp_alloy_logs_credentials" {
  value     = google_service_account_key.key.private_key
  sensitive = true
}



resource "google_service_account" "grafana" {
  account_id   = "grafana-stackdriver"
  display_name = "Grafana Stackdriver Access"
  project      = google_project.infra.project_id
}

resource "google_project_iam_member" "grafana_monitoring_viewer" {
  project = google_project.infra.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.grafana.email}"
}

resource "google_project_iam_member" "grafana_browser" {
  project = google_project.infra.project_id
  role    = "roles/browser"
  member  = "serviceAccount:${google_service_account.grafana.email}"
}

resource "google_service_account_key" "grafana_key" {
  service_account_id = google_service_account.grafana.name
  private_key_type    = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

output "grafana_service_account_key" {
  value     = google_service_account_key.grafana_key.private_key
  sensitive = true
}

