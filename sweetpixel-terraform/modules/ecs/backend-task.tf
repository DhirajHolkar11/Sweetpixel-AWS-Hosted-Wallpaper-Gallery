resource "aws_ecs_task_definition" "backend" {

  family = "wallpaper-backend"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = var.execution_role_arn

  task_role_arn = var.task_role_arn

  container_definitions = jsonencode([

    {

      name = "backend"

      image = var.backend_image

      essential = true

      portMappings = [

        {

          containerPort = 3000

          hostPort = 3000

          protocol = "tcp"

        }

      ]

      environment = [

        {
          name  = "PORT"
          value = "3000"
        },

        {
          name  = "AWS_REGION"
          value = var.aws_region
        },

        {
          name  = "AWS_BUCKET_NAME"
          value = var.bucket_name
        },

        {
          name  = "CLOUDFRONT_URL"
          value = var.cloudfront_url
        },

        {
          name  = "S3_URL"
          value = var.s3_url
        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "backend"

        }

      }

    }

  ])

}