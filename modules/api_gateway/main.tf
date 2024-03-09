resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "API to create a report from YouTube comments"
  body = templatefile("${path.module}/api.yml", {
    url                     = "https://execute-api.${var.region}.amazonaws.com/dev"
    integration_uri         = "arn:aws:apigateway:${var.region}:states:action/StartExecution"
    integration_credentials = aws_iam_role.api_gateway_role.arn
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_deployment" "deployment" {
  # depends_on  = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "dev"
  variables = {
    StateMachineArn = var.state_machine_arn
  }
}
