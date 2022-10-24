# 
# ECS cluster
# 
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cluster_name}"
  capacity_providers = var.auto_scaling_group_arn != "" ? [aws_ecs_capacity_provider.ecs_cluster.name] : []
  tags = {
    Name        = "${var.cluster_name}"
  }
}

resource "aws_ecs_capacity_provider" "ecs_cluster" {
  count = var.auto_scaling_group_arn != "" ? 1 : 0
  name = "capacity-provider-${var.cluster_name}"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.auto_scaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}