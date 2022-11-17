# DEPLOY LAMBDA FUNCTION AND API GATEWAY

### deploy lambda function
```terraform
module "py-lambda" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/lambda"

  source_dir = "./code"
  output_path = "./pylambda.zip"
  bucket = "mypylambdabucket"
  bucket_key = "code/pylambda.zip"
  function_name = "my-py-lambda"
  runtime = "python3.8"
  handler = "app.lambda_handler"
  timeout = 3
  memory_size = 128

}
```

### create api-gw
```terraform
module "api-gw" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/api-gateway"
  name = "demoapigw"
  description = "API gateway for demo"  
  domain = ""
  cors_configuration = {}
  stage = "v1"
}
```

### create api-gw protected by cognito authorizer
```terraform
module "api-gw" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/api-gateway"
  name = "demoapigw"
  description = "API gateway for demo"  
  domain = ""
  cors_configuration = {}
  stage = "v1"
  enable_cognito_authorizer = true
  cognito_client_id = var.cognito_client_id
  cognito_user_pool_id =  var.cognito_user_pool_id
  cognito_region = "eu-west-1"
}

```

### create endpoint
```terraform
module "hello-endpoint" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/api-gateway-integration"

  integration_type = "lambda"
  lambda_name = module.py-lambda.function_name
  lambda_arn = module.py-lambda.function_arn
  apigw_id =  module.api-gw.id
  apigw_execution_arn = module.api-gw.execution_arn
  method = "get" #or "GET"
  path = "/hello"

}
```

### create endpoint and protect with authorizer
```terraform
module "hello-endpoint" {
  source = "git::github.com/anotherbuginthecode/terraform-modules//modules/aws/api-gateway-integration"

  integration_type = "lambda"
  lambda_name = module.py-lambda.function_name
  lambda_arn = module.py-lambda.function_arn
  apigw_id =  module.api-gw.id
  apigw_execution_arn = module.api-gw.execution_arn
  method = "get" # or GET
  path = "/hello"

  enable_cognito_authorizer = true
  authorizer_id = module.api-gw.authorizer-id
}
```

### outputs
```terraform
output "function_name" {
  value = module.py-lambda.function_name
}

output "lambda_bucket_name" {
  value = module.py-lambda.lambda_bucket_name
}

output "api-gw-endpoint" {
  value = module.api-gw.endpoint
}
```
