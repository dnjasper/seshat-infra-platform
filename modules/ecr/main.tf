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

