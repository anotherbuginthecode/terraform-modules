variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}

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


# -- locals

locals {
  project_name = "demo-ecs"
  environment  = "dev"
  cluster_name = "demo-ecs"

}


# 1. -- create vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.project_name}-vpc-dev"
  cidr = "102.102.51.0/24"

  azs            = ["eu-west-1a", "eu-west-1b"]
  public_subnets = ["102.102.51.0/26", "102.102.51.64/26"]
  private_subnets = ["102.102.51.128/26", "102.102.51.192/26"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  public_subnet_suffix   = "public"
  private_subnet_suffix = "private"

  tags = {
    Environment = local.environment
  }

}

module "ecs-cluster" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/ecs-cluster"

  cluster_name = "demo-cluster"
  vpc_id = module.vpc.vpc_id
  log_group = "demo-cluster-log"  
}