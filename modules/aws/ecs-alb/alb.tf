resource "aws_lb" "lb" {
  name               = var.name
  load_balancer_type = "application"
  internal           = false
  subnets            = var.subnets
  tags = {
    Terraform = "true"
    Name = var.name
  }
  security_groups = [aws_security_group.lb.id]
}


resource "aws_lb_target_group" "lb_target_group" {
  name        = var.target_group_name
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    path                = var.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}