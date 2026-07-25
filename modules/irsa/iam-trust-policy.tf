data "aws_iam_policy_document" "seshat_trust_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    



    principals {
        type = "Federated"
       # identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.seshat_oidc_issuer}"]
         identifiers = [
           var.oidc_provider_arn]

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


  

  

