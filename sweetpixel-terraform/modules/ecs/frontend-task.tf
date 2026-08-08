resource "aws_ecs_task_definition" "frontend" {

  family = "wallpaper-frontend"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = var.execution_role_arn

  task_role_arn = var.task_role_arn

  container_definitions = jsonencode([

    {

      name = "frontend"

      image = var.frontend_image

      essential = true

      portMappings = [

        {

          containerPort = 80

          hostPort = 80

          protocol = "tcp"

        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = var.log_group_name

          awslogs-region = var.aws_region

          awslogs-stream-prefix = "frontend"

        }

      }

    }

  ])

}