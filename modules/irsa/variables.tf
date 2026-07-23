variable "cluster_name" {
    description = "The name of the EKS cluster"
    type = string
}

variable "oidc_provider_url" {
    description = "The URL of the OIDC provider"
    type = string
}

variable "namespace" {
    description = "The namespace for the service account"
    type = string
}

variable "service_account_name" {
    description = "The name of the service account"
    type = string
}

variable "oidc_provider_arn" {
    description = "The ARN of the OIDC provider"
    type = string
}   

# variable "oidc_thumbprint" {
#     description = "The thumbprint of the OIDC provider"
#     type = string
# }

variable "environment" {
    description = "The environment for the IRSA module"
    type = string
}

# variable "role_suffix" {
#   type        = string
#   description = "A unique suffix to prevent IAM name collisions across multiple module calls"
# }