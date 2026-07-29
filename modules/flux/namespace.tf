terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0" # Maps it to the official verified driver
    }
  }
}


resource "kubernetes_namespace_v1" "flux-system" {
 #  depends_on = [time_sleep.wait_for_eks]
  metadata {
    name = "flux-system"
  }
 
 timeouts {
   delete = "45s"
 }

}