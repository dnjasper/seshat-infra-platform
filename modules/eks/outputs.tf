

# output "cluster_name" {
#   value       = module.eks.cluster_id
#   description = "The EKS cluster name"
# }

output "cluster_name" {
  value = module.eks.cluster_name
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

# output "cluster_certificate_authority_auth" {
#   value = module.eks.cluster_certificate_authority_auth
# }

# output "oidc_thumbprint" {
#   value = aws_iam_openid_connect_provider.anubis_oidc_provider.thumbprint_list
# }