resource "aws_lb_target_group" "lb_target_group" {
  count = var.create_target_group ? 1 : 0
  name        = var.target_group_name
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    port                = var.ecs_target_port
    path                = var.health_check_path
    matcher             = "200" 
    protocol            = "HTTP"
    unhealthy_threshold = "3"
  }
}