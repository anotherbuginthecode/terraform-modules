provider "aws" {
  region  = "eu-west-1"
}


terraform {
  backend "s3" {
    bucket = "lambdademobucket-1"
    key    = "state/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "py-lambda" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/lambda"

  source_dir = "./code"
  output_path = "./pylambda.zip"
  bucket = "lambdademobucket-1"
  bucket_key = "code/pylambda.zip"
  function_name = "my-py-lambda"
  runtime = "python3.8"
  handler = "app.lambda_handler"
  timeout = 3
  memory_size = 128

}


# create api-gw
module "api-gw" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/api-gateway"
  name = "demoapigw"
  description = "API gateway for demo"  
  domain = ""
  cors_configuration = {}
  stage = "v1"
}

# create endpoint
module "hello-endpoint" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/api-gateway-integration"

  integration_type = "lambda"
  lambda_name = module.py-lambda.function_name
  lambda_arn = module.py-lambda.function_arn
  apigw_id =  module.api-gw.id
  apigw_execution_arn = module.api-gw.execution_arn
  method = "get"
  path = "/hello"

}

# outputs

output "function_name" {
  value = module.py-lambda.function_name
}

output "lambda_bucket_name" {
  value = module.py-lambda.lambda_bucket_name
}

output "api-gw-endpoint" {
  value = module.api-gw.endpoint
}