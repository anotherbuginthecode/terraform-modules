# 
# ECS cluster
# 
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cluster_name}"
  capacity_providers = var.ecs_capacity_provider
  tags = {
    Name        = "${var.cluster_name}"
  }
}