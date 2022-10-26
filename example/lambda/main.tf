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