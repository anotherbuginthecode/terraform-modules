resource "aws_apigatewayv2_api" "api-gw" {
  name          = var.name
  protocol_type = "HTTP"
  description = var.description
  disable_execute_api_endpoint =  var.domain != "" ? true : false
  cors_configuration = var.cors_configuration
}

resource "aws_apigatewayv2_stage" "api-gw" {
  api_id = aws_apigatewayv2_api.api-gw.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}


# certificate
data "aws_acm_certificate" "certificate" {
  count    = var.domain != "" ? 1 : 0
  domain   = var.domain
  statuses = ["ISSUED", "PENDING_VALIDATION"]
}

# route53 zone
data "aws_route53_zone" "zone" {
  count    = var.domain != "" ? 1 : 0
  name         = var.domain
  private_zone = true
}

resource "aws_apigatewayv2_domain_name" "api-gw" {
  count    = var.domain != "" ? 1 : 0
  domain_name = var.domain

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.certificate[0].arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "api-gw" {
  name    = aws_apigatewayv2_domain_name.api-gw.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.zone[0].zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.api-gw.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api-gw.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}