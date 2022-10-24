variable "log_group" {
}

variable "vpc_id" {
}

variable "cluster_name" {
}

variable "enable_ssh" {
  default = false
}

variable "ssh_sg" {
  default = ""
}

variable "ssh_cidr_blocks" {
  default = ""
}

variable "log_retention_days" {
  default = 0
}

variable "ecs_capacity_provider" {
  type = list(string)
  default = []
}