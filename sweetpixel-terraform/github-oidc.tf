############################################
# GitHub Actions OIDC Provider
############################################

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  # GitHub Actions OIDC provider thumbprint
  # commonly used by AWS IAM
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = {
    Project   = "Sweetpixel"
    ManagedBy = "Terraform"
  }
}

############################################
# GitHub Actions IAM Role
############################################

resource "aws_iam_role" "github_actions_sweetpixel" {
  name = "github-actions-sweetpixel"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:DhirajHolkar11/Sweetpixel-AWS-Hosted-Wallpaper-Gallery:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    Project   = "Sweetpixel"
    ManagedBy = "Terraform"
  }
}

############################################
# ECR and ECS Deployment Permissions
############################################

resource "aws_iam_role_policy" "github_actions_sweetpixel" {
  name = "github-actions-sweetpixel-deploy-policy"
  role = aws_iam_role.github_actions_sweetpixel.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECRAuthorization"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Sid    = "PushImagesToECR"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = [
          "arn:aws:ecr:ap-south-1:274703560582:repository/wallpaper-frontend",
          "arn:aws:ecr:ap-south-1:274703560582:repository/wallpaper-backend"
        ]
      },
      {
        Sid    = "DeployToECS"
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ]
        Resource = [
          "arn:aws:ecs:ap-south-1:274703560582:service/wallpaper-cluster/wallpaper-frontend-service",
          "arn:aws:ecs:ap-south-1:274703560582:service/wallpaper-cluster/wallpaper-backend-service"
        ]
      }
    ]
  })
}

############################################
# Output
############################################

output "github_actions_role_arn" {
  description = "IAM role assumed by GitHub Actions"
  value       = aws_iam_role.github_actions_sweetpixel.arn
}