variable "task_def_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "memory" {
  type = number
}

variable "cpu" {
  type = number
}

variable "container_definitions" {
  type = string
}

variable "environment" {
  type = string
}