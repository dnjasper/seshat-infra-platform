resource "aws_iam_role" "seshat_role" {
    name = "seshat_role_${var.namespace}"

   assume_role_policy = data.aws_iam_policy_document.seshat_trust_policy.json
   }