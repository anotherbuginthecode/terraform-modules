variable "service_name" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "task_count" {
  type = number
  default = 1
}

variable "ordered_placement_strategy_type" {
  type = string
  default = "binpack"
}

variable "ordered_placement_strategy_field" {
  type = string
  default = "cpu"
}

variable "target_group_arn" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = number
}

