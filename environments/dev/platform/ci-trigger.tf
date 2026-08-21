resource "null_resource" "trigger_ci" {
  depends_on = [module.flux]
  triggers = {
    ecr_name = "seshat-api"
  }

  provisioner "local-exec" {
    command = "curl -v --fail-with-body -L -X POST -H 'Accept: application/vnd.github+json' -H 'Authorization: Bearer ${var.github_token}' https://api.github.com/repos/dnjasper/seshat-workload-platform/actions/workflows/app-pipeline.yaml/dispatches -d '{\"ref\":\"main\"}'"

  }

  lifecycle {
    ignore_changes = all
  }
}
