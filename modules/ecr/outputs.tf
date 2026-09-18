output "ecr_repository_url" {
    value = aws_ecr_repository.seshat_api.repository_url
    description = "The URL of the ECR repository"
}

output "upf_ecr_repository_url" {
  value       = aws_ecr_repository.upf_worker.repository_url
  description = "The URL of the private ECR repository for the UPF workload"
}