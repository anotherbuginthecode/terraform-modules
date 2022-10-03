resource "aws_apigatewayv2_route" "route-lambda" {
  count = var.integration_type == "lambda" ? 1 : 0
  api_id =  var.api_id
  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda-integration.id[0]}"
}
