resource "kubernetes_namespace_v1" "flux-system" {
 #  depends_on = [time_sleep.wait_for_eks]
  metadata {
    name = "flux-system"
  }
 
 timeouts {
   delete = "45s"
 }

}