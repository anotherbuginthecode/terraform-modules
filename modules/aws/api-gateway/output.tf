output "api-gw-endpoint" {
  value = aws_apigatewayv2_api.api-gw.api_endpoint
}

output "api-gw-execution-arn" {
  value = aws_apigatewayv2_api.api-gw.execution_arn
}