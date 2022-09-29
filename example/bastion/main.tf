variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable "cidr_block" {}
variable "keypair_name" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


// get default VPC and first public subnet

data "aws_vpcs" "default" {
  tags = {
    Name = "default"
  }
}

data "aws_subnets" "subnet" {
  filter {
    name   = "vpc-id"
    values = [ data.aws_vpcs.default.ids[0] ]
  }
}

module "bastion" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/bastion"

  name = "bastion-example"
  vpc_id = data.aws_vpcs.default.ids[0]
  subnet_id = data.aws_subnets.subnet.ids[0]
  instance_type = "t3.nano"
  ingress_cidr = var.cidr_block
  keypair_name = var.keypair_name

}