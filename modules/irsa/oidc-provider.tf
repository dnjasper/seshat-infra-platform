resource "aws_iam_openid_connect_provider" "seshat_oidc_provider" {
    url = var.oidc_provider_url
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = ["9e2b912293c56a815a513c0b0292ec9fb2ca1e27"]
}

data "tls_certificate" "github" {
    url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
    url = "https://token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}