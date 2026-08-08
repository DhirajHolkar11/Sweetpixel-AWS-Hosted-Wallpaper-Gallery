####################################
# ECS Task Execution Role
####################################

resource "aws_iam_role" "ecs_task_execution_role" {

  name = "wallpaper-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

####################################
# Attach AWS Managed Policy
####################################

resource "aws_iam_role_policy_attachment" "execution_policy" {

  role = aws_iam_role.ecs_task_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

####################################
# ECS Task Role
####################################

resource "aws_iam_role" "ecs_task_role" {

  name = "wallpaper-ecs-task-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"

      }

    ]

  })
}

####################################
# S3 Access Policy
####################################

resource "aws_iam_policy" "s3_access" {

  name = "wallpaper-s3-access-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]

        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      }

    ]

  })

}

####################################
# Attach Policy
####################################

resource "aws_iam_role_policy_attachment" "task_s3_policy" {

  role = aws_iam_role.ecs_task_role.name

  policy_arn = aws_iam_policy.s3_access.arn

}