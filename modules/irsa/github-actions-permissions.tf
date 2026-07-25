resource "aws_iam_role_policy" "github_actions_tfstate" {
  name = "github-actions-tfstate-access"

  role = aws_iam_role.github_actions_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          "arn:aws:s3:::seshat-infra-tfstate"
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = [
          "arn:aws:s3:::seshat-infra-tfstate/*"
        ]
      }
    ]
  })
}