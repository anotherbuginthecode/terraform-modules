# get the most up-to-date AWS EC2 AMI that is ECS optimized.
data "aws_ami" "aws_optimized_ecs" {
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

  owners = ["591542846629"] # Canonical
}

resource "aws_launch_configuration" "ecs_config_launch_config_spot" {
  count = var.ec2_spot ? 1 : 0
  name_prefix                 = "${var.cluster_name}-${var.cluster_environment}-ecs-spot"
  image_id                    = data.aws_ami.aws_optimized_ecs.id
  instance_type               = var.instance_type
  key_name                    = var.ssh_keypair
  security_groups             = [var.cluster_sg]
  spot_price                  = var.spot_bid_price
  # associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
#!/bin/bash
echo 'ECS_CLUSTER=${cluster_name}' > /etc/ecs/ecs.config
start ecs
EOF

  iam_instance_profile = var.iam_instance_profile == "" ? aws_iam_instance_profile.ecs_agent.arn : var.iam_instance_profile
}

resource "aws_launch_configuration" "ecs_config_launch_config_default" {
  count = var.ec2_spot ? 0 : 1
  name_prefix                 = "${var.cluster_name}-${var.cluster_environment}-ecs-spot"
  image_id                    = data.aws_ami.aws_optimized_ecs.id
  instance_type               = var.instance_type
  key_name                    = var.ssh_keypair
  security_groups             = [var.cluster_sg]
  # associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
#!/bin/bash
echo 'ECS_CLUSTER=${cluster_name}' > /etc/ecs/ecs.config
start ecs
EOF

  iam_instance_profile = var.iam_instance_profile == "" ? aws_iam_instance_profile.ecs_agent.arn : var.iam_instance_profile
}