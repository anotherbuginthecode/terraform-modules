variable "lb_name" {
  type = string
}

variable "internal" {
  type = bool
  default = false
}

variable "vpc_id" {
  type = string
}

variable "vpc_subnets" {
  type =  list(string)
}

variable "domain" {
  type = string
}

# variable "default_target_arn" {
#   default = ""
# }

variable "ecs_sg" {
  default = []
}

variable "tls" {
  default = true
}

variable "tls_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

variable "idle_timeout" {
  default = 60
}

variable "access_logs" {
  description = "An access logs block"
  type        = map(string)
  default     = {}
}

variable "tcp_ingress" {
  type = map(list(string))
  default = {
    "80" = [ "0.0.0.0/0" ]
    "443" = [ "0.0.0.0/0" ]
  }
}

variable "allow_additional_sg" {
  type = map(object({
    security_groups = list(string)
    from_port       = string
    to_port         = string
    protocol        = string
  }))
  default = {}
}

variable "create_target_group" {
  type = bool
  default = false
}

variable "target_group_name" {
  type = string
  default = ""
}

variable "target_group_port_protocol" {
  type = string
  default = "HTTP"
}

variable "ecs_target_port" {
  type = string
}

variable "health_check_path" {
  type = string
  default = "/"
}

