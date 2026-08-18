resource "aws_iam_role_policy" "github_actions_repo3" {
  name = "github-actions-repo_3-access"

  role = aws_iam_role.github_actions_repo3_role.id

  policy = jsonencode({
    "Version":"2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:CompleteLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:BatchGetImage"
            ],
            "Resource": "arn:aws:ecr:us-east-1:468402787427:repository/seshat-workload-platform"
        },
        {
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        }
    ]
})

}