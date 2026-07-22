resource "aws_iam_role_policy_attachment" "seshat_attach" {
    role = aws_iam_role.seshat_role.name
    policy_arn = aws_iam_policy.seshat_policy.arn
}

resource "aws_iam_role_policy_attachment" "github_ecr_access" {
    role = aws_iam_role.github_actions_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}