resource "aws_ecs_service" "backend" {

  name = "wallpaper-backend-service"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.backend.arn

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

    target_group_arn = var.backend_target_group_arn

    container_name = "backend"

    container_port = 3000

  }

  depends_on = [
    aws_ecs_task_definition.backend
  ]

}