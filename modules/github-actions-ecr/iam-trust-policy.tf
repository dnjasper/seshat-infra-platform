# data "aws_iam_policy_document" "github_actions_repo3_trust_policy" {
#     statement {
#       effect = "Allow"
#       actions = ["sts:AssumeRoleWithWebIdentity"]


#         principals {
#           type        = "Federated"
#           identifiers = ["arn:aws:iam::468402787427:oidc-provider/token.actions.githubusercontent.com"]
#         } 
  

#          condition {
#           test     = "StringEquals"
#           variable = "token.actions.githubusercontent.com:aud"
#           values   = ["sts.amazonaws.com"]
#          }

#          condition { 
#           test = "StringLike"
#           variable = "token.actions.githubusercontent.com:sub"
#          # values   = ["repo:dnjasper/seshat-workload-platform:*"]
#           values   = ["repo:${var.github_repository_repo3}:*"]
#      }
#   }
# }