resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.api-gateway.name}"

  retention_in_days = 30
}
