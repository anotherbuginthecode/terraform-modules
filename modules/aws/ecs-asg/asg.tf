data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

resource "aws_launch_configuration" "lc" {

  name          = "${var.cluster_name}-launch-configuration"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  security_groups             = ["${aws_security_group.cluster.id}"]
  associate_public_ip_address = true
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF

}

resource "aws_autoscaling_group" "asg" {

  name                      = "${var.cluster_name}-asg"
  launch_configuration      = aws_launch_configuration.lc.name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.min_size
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = var.subnets

  target_group_arns     = [var.target_group_arn]
  force_delete          = var.force_delete
  protect_from_scale_in = var.protect_from_scale_in
  placement_group           = var.create_placement_strategy ? one(aws_placement_group.strategy[*].id) : null
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-ec2"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}