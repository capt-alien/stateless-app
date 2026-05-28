output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "go_ecr_repository_url" {
  value = aws_ecr_repository.go_service.repository_url
}

output "swift_ecr_repository_url" {
  value = aws_ecr_repository.swift_service.repository_url
}