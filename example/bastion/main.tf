variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable "keypair_name" {}
variable "path_to_public_key" {}
variable "ingress_cidr" {}


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

// find my ip
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}



module "bastion" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/bastion"

  name = "bastion-example"
  vpc_id = data.aws_vpcs.default.ids[0]
  subnet_id = data.aws_subnets.subnet.ids[0]
  instance_type = "t3.nano"
  ingress_cidr = ["${chomp(data.http.myip.body)}/32"]
  keypair_name = var.keypair_name
  path_to_public_key = var.path_to_public_key
  associate_eip = true

}

output "bastion-sg" {
  value = module.bastion.bastion-security-group-id
}

output "bastion-ip" {
  value = module.bastion.bastion-ip
}