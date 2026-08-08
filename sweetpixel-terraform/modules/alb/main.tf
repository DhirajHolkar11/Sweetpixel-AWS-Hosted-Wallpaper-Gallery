resource "aws_lb" "wallpaper_alb" {

  name = "wallpaper-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = [
    var.public_subnet_1_id,
    var.public_subnet_2_id
  ]

  tags = {
    Name = "Wallpaper-ALB"
  }

}

#################################################
# Frontend Target Group
#################################################

resource "aws_lb_target_group" "frontend_tg" {

  name = "wallpaper-frontend"

  port = 80

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = "/"

    protocol = "HTTP"

    matcher = "200"

  }

  lifecycle {

    create_before_destroy = true

  }

}

#################################################
# Backend Target Group
#################################################

resource "aws_lb_target_group" "backend_tg" {

  name = "wallpaper-backend"

  port = 3000

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = "/api/images"

    protocol = "HTTP"

    matcher = "200"

  }

  lifecycle {

    create_before_destroy = true

  }

}

#################################################
# HTTP Listener
#################################################

resource "aws_lb_listener" "http_listener" {

  load_balancer_arn = aws_lb.wallpaper_alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.frontend_tg.arn

  }

}

#################################################
# Route /api/* to Backend
#################################################

resource "aws_lb_listener_rule" "backend_api_rule" {

  listener_arn = aws_lb_listener.http_listener.arn

  priority = 100

  action {

    type = "forward"

    target_group_arn = aws_lb_target_group.backend_tg.arn

  }

  condition {

    path_pattern {

      values = ["/api/*"]

    }

  }

}