resource "aws_ecs_task_definition" "task_definition" {
  family             = var.task_def_name
  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  memory             = var.memory
  cpu                = var.cpu
  container_definitions = jsonencode(var.container_definitions)
  tags = merge(
    var.common_tags,
    {
      Name = var.task_def_name
      Terraform = "true"
      Environment = "${var.environment}"
    }
  )
}