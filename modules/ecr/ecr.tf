resource "aws_ecr_repository" "seshat_api" {
    name = "seshat_api"
    image_tag_mutability = "MUTABLE"

    force_delete = true
    image_scanning_configuration {
        scan_on_push = true
    }

    tags = {
      Name = "seshat-api-registry"
      Environment = var.environment
    }
}

output "ecr_repository_url" {
    value = aws_ecr_repository.seshat_api.repository_url
    description = "The URL of the ECR repository"
}