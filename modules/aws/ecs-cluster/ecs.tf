resource "aws_ecs_cluster" "cluster" {
  name               = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.cluster.name]
  tags = {
    "Terraform"       = "true"
  }
}

resource "aws_ecs_capacity_provider" "cluster" {
  name = "${var.cluster_name}-capacity-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}
