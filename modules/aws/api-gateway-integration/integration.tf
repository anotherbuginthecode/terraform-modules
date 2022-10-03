resource "aws_apigatewayv2_integration" "lambda-integration" {
  count = var.integration_type == "lambda" ? 1 : 0

  api_id = var.api_id
  integration_type   = "AWS_PROXY"
  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda ${var.lambda_arn} integration"
  integration_method = var.integration_method
  integration_uri    = var.lambda_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}

