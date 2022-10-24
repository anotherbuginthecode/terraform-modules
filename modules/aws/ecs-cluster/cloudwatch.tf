resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.cluster_name}-${var.cluster_environment}-logs"

  tags = {
    Application = var.cluster_name
    Environment = var.cluster_environment
  }
}
