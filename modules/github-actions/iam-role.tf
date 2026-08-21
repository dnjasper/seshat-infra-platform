

resource "aws_iam_role" "github_actions_role" {
  name = "github_actions_role"
assume_role_policy = data.aws_iam_policy_document.github_actions_trust_policy.json

lifecycle {
    prevent_destroy = true
  }

}