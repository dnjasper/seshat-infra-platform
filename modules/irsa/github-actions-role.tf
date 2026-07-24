data "aws_iam_policy_document" "github_actions_trust_policy" {
    statement {
      effect = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]


        principals {
          type        = "Federated"
          identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
        } 
  

         condition {
          test     = "StringEquals"
          variable = "token.actions.githubusercontent.com:aud"
          values   = ["sts.amazonaws.com"]
         }

         condition { 
          test = "StringEquals"
          variable = "token.actions.githubusercontent.com:sub"
          values   = ["repo:dnjasper/seshat-infra-platform:*"]
     }
  }
}




resource "aws_iam_role" "github_actions_role" {
  name = "github_actions_role_${var.namespace}"
  count = var.namespace == "flux-system" ? 1 : 0
assume_role_policy = data.aws_iam_policy_document.github_actions_trust_policy.json

}