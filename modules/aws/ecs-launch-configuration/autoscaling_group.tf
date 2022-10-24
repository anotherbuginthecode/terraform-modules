resource "aws_autoscaling_group" "ecs_asg" {
  name_prefix = "${var.cluster_name}-${var.cluster_environment}-asg"
  termination_policies = [
     "OldestInstance", "default"
  ]
  default_cooldown          = 30
  health_check_grace_period = 30
  max_size                  = var.max_instances
  min_size                  = var.min_instances
  desired_capacity          = var.min_instances

  launch_configuration      = var.ec2_spot ? aws_launch_configuration.ecs_config_launch_config_spot.name : aws_launch_configuration.ecs_config_launch_config_default.name

  lifecycle {
    create_before_destroy = true
  }
  vpc_zone_identifier = var.vpc_id

  tags = [
    {
      key                 = "Name"
      value               = var.cluster_name,
      propagate_at_launch = true
    },
    {
      key                 = "Spot"
      value               = var.ec2_spot,
      propagate_at_launch = true
    }
  ]
}