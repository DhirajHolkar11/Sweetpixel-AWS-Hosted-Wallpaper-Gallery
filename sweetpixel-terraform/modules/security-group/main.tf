resource "aws_security_group" "alb_sg" {

  name        = "wallpaper-alb-sg"
  description = "Security Group for ALB"
  vpc_id      = var.vpc_id

  ingress {

    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "Wallpaper-ALB-SG"

  }

}

resource "aws_security_group" "ecs_sg" {

  name        = "wallpaper-ecs-sg"
  description = "Security Group for ECS Tasks"

  vpc_id = var.vpc_id

  ingress {

    description = "Traffic from ALB"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]

  }

  ingress {

    description = "Backend Port"

    from_port = 3000
    to_port   = 3000

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]

  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "Wallpaper-ECS-SG"

  }

}