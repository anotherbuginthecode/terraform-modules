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