variable "aws_region" {
  description = "AWS region for stateless-app lab"
  type        = string
  default     = "us-west-2"
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

variable "aws_lb_hostname" {
  description = "Current AWS LoadBalancer hostname for stateless app"
  type        = string
  default     = ""
}