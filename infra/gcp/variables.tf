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
  default     = "us-central1-a"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "stateless-app"
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for captalien.io"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token for DNS updates"
  type        = string
  sensitive   = true
}

variable "gcp_lb_ip" {
  description = "Current GCP LoadBalancer IP for stateless app"
  type        = string
  default     = ""
}