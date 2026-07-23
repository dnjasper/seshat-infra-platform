data "aws_caller_identity" "current" {}

# data "aws_eks_cluster" "seshat" {
#     name = "${var.cluster_name}-cluster"
# }

locals {
    seshat_oidc_issuer = replace(var.oidc_provider_url, "https://","")
}






data "aws_iam_policy_document" "seshat_trust_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    



    principals {
        type = "Federated"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.seshat_oidc_issuer}"]
    }


    condition {
        test = "StringEquals"
        variable = "${local.seshat_oidc_issuer}:sub"
        values = [
            "system:serviceaccount:${var.namespace}:${var.service_account_name}"
        ]
     }   
   
    condition {
        test = "StringEquals"
        variable = "${local.seshat_oidc_issuer}:aud"
        values = ["sts.amazonaws.com"]
    }
  }
}



   resource "aws_iam_role" "seshat_role" {
    name = "seshat_role_${var.namespace}"

   assume_role_policy = data.aws_iam_policy_document.seshat_trust_policy.json
   }

  data "aws_iam_policy_document" "github_actions_trust_policy" {
    statement {
      effect = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]


        principals {
          type        = "Federated"
          identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/://githubusercontent.com"]
        } 
  

         condition {
          test     = "StringEquals"
          variable = "://githubusercontent.com:aud"
          values   = ["sts.amazonaws.com"]
         }

         condition { 
          test = "StringEquals"
          variable = "://githubusercontent.com:sub"
          values   = ["repo:dnjasper/seshat-app-delivery:*"]
     }
  }
}
resource "aws_iam_role" "github_actions_role" {
  name = "github_actions_role_${var.namespace}"

assume_role_policy = data.aws_iam_policy_document.github_actions_trust_policy.json

}

