provider "aws" {
  region  = "eu-west-1"
}


terraform {
  backend "s3" {
    bucket = "ecsdemobucket"
    key    = "state/terraform.tfstate"
    region = "eu-west-1"
  }
}

# 1. -- create vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "demoecs-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  public_subnet_suffix   = "public"
  private_subnet_suffix = "private"
  tags = {
    "Name" = "demoecs-vpc"
  }
}

# 2. -- create iam 
module "ecs-iam" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/ecs-iam"
  cluster_name = "demoecs"
}

# 3. -- create application loadbalancer
module "ecs-alb" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/ecs-alb"

  name = "demoecs-alb"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  tcp_ingress = {
    "80" = ["0.0.0.0/0"]
  }

  target_group_name = "demoecs-tg"
  health_check_path = "/index.html"

  depends_on = [
    module.vpc
  ]
  
}

# 4. -- create auto-scaling group
module "ecs-asg" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/ecs-asg"

  cluster_name = "demoecs"
  instance_type = "t2.micro"
  key_name = "lab-ssh-key"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  target_group_arn = module.ecs-alb.tg_arn
  iam_instance_profile = module.ecs-iam.iam_instance_profile
  create_placement_strategy = false
  force_delete = true
  protect_from_scale_in = true

  tcp_ingress = {
    "22": ["0.0.0.0/0"]
  }

  loadbalancer_sg = module.ecs-alb.lb_sg

  min_size = 1
  max_size = 3

  depends_on = [
    module.vpc,
  ]
}

# 5. -- create ecs cluster
module "ecs-cluster"{
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/ecs-cluster"

  cluster_name = "demoecs"
  asg_arn = module.ecs-asg.arn

  depends_on = [
    module.ecs-asg
  ]
}

# 5. -- create task definition
module "nginx-task-def" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/ecs-task"

  # cluster_name = "demoecs"
  task_name = "nginx-task-def"
  task_definition = file("container-definitions/nginx.json") # remember to replace with your info
  network_mode = "bridge"
}

# 6. -- create service 
module "nginx-service" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/ecs-service"

  service_name = "nginx-service"
  cluster_id = module.ecs-cluster.id
  cluster_name = module.ecs-cluster.name
  task_definition_arn = module.nginx-task-def.arn
  desired_task_count = 1
  max_task_count = 2
  enable_autoscaling = false
  # target_average_cpu_utilizazion = 80
  # target_average_memory_utilizazion = 80
  target_group_arn = module.ecs-alb.tg_arn
  container_name = "nginx"
  container_port = 80
}

# outputs

output "cluster" {
  value = module.ecs-cluster.name
}

output "cluster_id" {
  value = module.ecs-cluster.id
}

output "loadbalancer-endpoint" {
  value = module.ecs-alb.endpoint
}

output "asg-name" {
  value = module.ecs-asg.name
}