variable "environment" {
    description = "The environment for the ECR repository"
    type = string
}

variable "github_token" {
    description = "The GitHub token for accessing private repositories"
    type = string
}