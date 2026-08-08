resource "aws_ecs_task_definition" "wallpaper_task" {

  family = "wallpaper-task"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu = "512"

  memory = "1024"

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
          hostPort      = 80
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

    },

    {

      name = "backend"

      image = var.backend_image

      essential = true

      portMappings = [

        {

          containerPort = 3000

          hostPort = 3000

        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = var.log_group_name

          awslogs-region = var.aws_region

          awslogs-stream-prefix = "backend"

        }

      }

    }

  ])

}