variable "cluster_name" {
  type        = string
  description = "the name of an ECS cluster"
}

variable "cluster_environment" {
  type        = string
  description = "the ECS cluster environment"
  default     = "prod"
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "iam_instance_profile" {
  type = string
  default = ""
}

variable "create_ec2_sg" {
  type = bool
  default = false
}

variable "volume_size" {
  type = number
  default = 30
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

variable "ssh_keypair" {
  type = string
  description = "(optional) keypair to ssh connection"
}