variable "gcp_project_id" {
  description = "GCP project ID for stateless-app"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-west1"
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "us-west1-a"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "stateless-app"
}