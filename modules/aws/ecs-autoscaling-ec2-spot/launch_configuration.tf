resource "aws_launch_configuration" "ecs_config_launch_config_spot" {
  name_prefix                 = "${var.cluster_name}_ecs_cluster_spot"
  image_id                    = data.aws_ami.aws_optimized_ecs.id
  instance_type               = var.instance_type_spot
  spot_price                  = var.spot_bid_price
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
EOF

  security_groups = var.create_ec2_spot_sg ? [aws_security_group.ec2_sg.security_group_id] : var.ecs_sg
  key_name             = var.ssh_keypair
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.arn
}