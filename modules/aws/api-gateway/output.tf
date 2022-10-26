output "endpoint" {
  value = aws_apigatewayv2_api.api-gw.api_endpoint
}

output "id" {
  value = aws_apigatewayv2_api.api-gw.id
}

output "execution_arn" {
  value = aws_apigatewayv2_api.api-gw.execution_arn
}