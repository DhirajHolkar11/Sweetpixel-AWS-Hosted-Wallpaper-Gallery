resource "aws_ecs_service" "frontend" {

  name = "wallpaper-frontend-service"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.frontend.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.subnet_ids

    security_groups = [
      var.ecs_security_group_id
    ]

    assign_public_ip = true

  }

  load_balancer {

    target_group_arn = var.frontend_target_group_arn

    container_name = "frontend"

    container_port = 80

  }

  depends_on = [
    aws_ecs_task_definition.frontend
  ]

}