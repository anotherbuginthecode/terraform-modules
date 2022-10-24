resource "aws_ecs_capacity_provider" "cluster" {
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