resource "aws_ecs_service" "service" {
  cluster                = var.cluster_id
  desired_count          = var.desired_count
  launch_type            = "EC2"
  name                   = "${var.serivce_name}" 
  task_definition        = "${var.task_definition_arn}" 
  load_balancer {
    container_name       = "${var.container_name}"
    container_port       = "${var.container_port}"
    target_group_arn     = "${var.target_group_arn}"
 }
  network_configuration {
    security_groups       = ["${var.service_sg}", "${var.loadbalancer_sg}"]
    subnets               = var.subnet_ids
    assign_public_ip      = "false"
  }
}