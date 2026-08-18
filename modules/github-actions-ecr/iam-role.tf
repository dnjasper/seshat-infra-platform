resource "aws_iam_role" "github_actions_repo3_role" {
    name = "github_actions_repo3_role"
    assume_role_policy = data.aws_iam_policy_document.github_actions_repo3_trust_policy.json
}