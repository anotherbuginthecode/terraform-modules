# TERRAFORM + AWS = create a new vpc

### How to use
~~~
provider "aws" {
	region = "eu-west-1"
}

module "vpc" {
    source = "git::https://github.com/anotherbuginthecode/terraform//modules/aws/vpc"
    vpc_name = "my-vpc"
    cidr = "10.0.0.0/16"
    
    azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets = ["10.0.101.0/24", "10.0.102.0/24",  "10.0.103.0/24"]

    map_public_ip_on_launch = true
    public_subnet_suffix = "public"
    private_subnet_suffix = "private"
}
~~~