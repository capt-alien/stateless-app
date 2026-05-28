data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_ecr_repository" "go_service" {
  name = "${var.project_name}-go"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "swift_service" {
  name = "${var.project_name}-swift"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}