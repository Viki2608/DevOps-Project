output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "repository_id" {
  description = "The ID of the ECR repository"
  value       = aws_ecr_repository.app.id
}
