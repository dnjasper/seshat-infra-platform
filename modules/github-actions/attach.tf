resource "aws_iam_role_policy_attachment" "gha_execution_power" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" 
}