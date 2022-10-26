# variable "cluster_name" {
#   type = string
# }

variable "task_name" {
  type = string
}

variable "task_definition" {
  type = string
}

variable "network_mode" {
  type = string
  default = "bridge"
}

