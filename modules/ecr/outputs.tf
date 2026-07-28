output "ecr_repository_url" {
    value = aws_ecr_repository.seshat_api.repository_url
    description = "The URL of the ECR repository"
}