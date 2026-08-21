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
          values   =  [
            "repo:dnjasper@26615875/seshat-infra-platform@1308985333:ref:refs/heads/main"
          ]
       #   values   = ["repo:dnjasper@26615875/seshat-infra-platform@1308985333:*"]
        #  values   = ["repo:${var.github_repository}:*"]
     }
  }
}










