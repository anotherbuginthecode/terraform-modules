resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cluster_name}-${var.cluster_environment}-cluster"
  tags = {
    Name        = "${var.cluster_name}-ecs"
    Environment = var.cluster_environment
  }
}