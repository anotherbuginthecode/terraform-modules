variable "name" {
  description = "(Required) name of the bastion"
  default = "t3.nano"
}

variable "vpc_id" {
  description = "(Required) vpc id"
}

variable "subnet_id" {
  description = "(Required) subnet id to launch bastion in"
}

variable "instance_type" {
  description = "(Required) bastion instance type"
}

variable "ingress_cidr" {
  description = "(Required) bastion ingress cidr block to allow"
}

variable "keypair_name" {
  description = "(Required) name of the ssh keypair to use"
}

variable "root_block_device_encryption" {
  description = "(Optional) encrypt root block device. Default true"
  default     = true
}

variable "associate_eip" {
  type = bool
  description = "(Optional) if true an elastic ip will be associated to the bastion host"
  default = false
}