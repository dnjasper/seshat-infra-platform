resource "kubernetes_secret_v1" "flux-git-deploy" {
  depends_on = [
    kubernetes_namespace_v1.flux-system
  ]
  metadata {
    name = "flux-git-deploy"
    namespace = "flux-system"
  }
  type = "Opaque"
  
  

  data = {
    identity     = var.identity_private_key
    "identity.pub" = var.identity_public_key
    known_hosts  = var.known_hosts
  }
} 