locals {
    seshat_oidc_issuer = replace(var.oidc_provider_url, "https://","")
}