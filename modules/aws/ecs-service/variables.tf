variable "cluster_id" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "service_name" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "service_sg" {
  type = string
}

variable "loadbalancer_sg" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}