resource "aws_ecs_task_definition" "task-definition" {
  family                = var.task_name
  container_definitions = var.task_definition
  network_mode          = var.network_mode
  task_role_arn         = var.task_role_arn
  execution_role_arn    = var.execution_role_arn
  tags = {
    "Terraform" = "true"
  }
}