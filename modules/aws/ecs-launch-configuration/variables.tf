variable "vpc_id" {
  type = string
}

variable "instance_type" {
  default = "t3a.medium"
  type    = string
}

variable "spot_bid_price" {
  default     = "0.0175"
  description = "How much you are willing to pay as an hourly rate for an EC2 instance, in USD"
}

variable "cluster_name" {
  type        = string
  description = "the name of an ECS cluster"
}

variable "cluster_environment" {
  type        = string
  description = "the ECS cluster environment"
  default     = "prod"
}

variable "min_spot" {
  default     = "2"
  description = "The minimum EC2 spot instances to be available. Default is 2"
}

variable "max_spot" {
  default     = "5"
  description = "The maximum EC2 spot instances that can be launched at peak time. Default is 5"
}


variable "ssh_keypair" {
  type = string
  description = "(optional) keypair to ssh connection"
}

variable "iam_instance_profile" {
  type = string
  default = ""
}

variable "ec2_spot" {
  type = bool
  default = false
}