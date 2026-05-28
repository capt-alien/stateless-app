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