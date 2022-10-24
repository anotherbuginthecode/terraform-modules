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

resource "aws_instance" "ec2_instance" {
  ami                    =  data.aws_ami.aws_optimized_ecs.image_id
  subnet_id              =  var.subnet_id
  instance_type          =  var.instance_type
  iam_instance_profile   =  var.iam_instance_profile == "" ? "ecsInstanceRole" : var.iam_instance_profile
  vpc_security_group_ids =  var.create_sg ? [aws_security_group.ec2_sg[*].arn] : var.security_group_id
  key_name               =  var.allow_ssh ? var.ssh_keypair : null
  ebs_optimized          = "false"
  source_dest_check      = "false"
  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y ecs-init
sudo service docker start
sudo start ecs
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"
EOF
  root_block_device = {
    volume_type           = "gp2"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "true"
  }

  tags {
    Name                   = "${var.cluster_name}-ec2"
    CreatedAt              = timestamp()
}

  lifecycle {
    ignore_changes         = ["ami", "user_data", "subnet_id", "key_name", "ebs_optimized", "private_ip"]
  }
}
