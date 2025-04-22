variable "project_name" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to use (ex. global or us-east1)"
  type        = string
}

variable "gcp_org_id" {
  description = "The organization id to create the project under"
  type        = string
  nullable = false
}

variable billing_account {
    description = "The billing account to associate with the project"
    type        = string
    nullable = false
}