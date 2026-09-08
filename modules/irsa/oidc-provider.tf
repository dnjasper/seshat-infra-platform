

data "tls_certificate" "github" {
    url = "https://token.actions.githubusercontent.com"
}

