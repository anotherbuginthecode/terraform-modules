resource "aws_ecs_task_definition" "task-definition" {
  family                = var.task_name
  container_definitions = var.task_definition
  network_mode          = var.network_mode
  tags = {
    "Terraform" = "true"
  }
}