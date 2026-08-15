resource "kubernetes_secret_v1" "seshat-deploy" {
  depends_on = [
    kubernetes_namespace_v1.flux-system
  ]
  metadata {
    name = "seshat-deploy"
    namespace = "flux-system"
  }
  type = "Opaque"
  
  

  data = {
    identity     = var.identity_private_key
    "identity.pub" = var.identity_public_key
    known_hosts  = var.known_hosts
  }
} 