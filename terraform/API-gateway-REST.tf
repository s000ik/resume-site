# Create REST API
resource "aws_api_gateway_rest_api" "RESTapi" {
  name = var.api_gateway_name

#   endpoint_configuration {
#     types = ["REGIONAL"] 
#   }

  tags = {
    Project = var.project_name
  }
}

# Create GET Method on the root resource
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.RESTapi.id
  resource_id   = aws_api_gateway_rest_api.RESTapi.root_resource_id # Use root resource
  http_method   = "GET"
  authorization = "NONE"
}

# Create Lambda Integration
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.RESTapi.id
  resource_id             = aws_api_gateway_rest_api.RESTapi.root_resource_id # Use root resource
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.cloud-resume-func-but-terraformed.invoke_arn
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
}

# Create Method Response
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.RESTapi.id
  resource_id = aws_api_gateway_rest_api.RESTapi.root_resource_id # Use root resource
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# Create Integration Response
resource "aws_api_gateway_integration_response" "lambda_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.RESTapi.id
  resource_id = aws_api_gateway_rest_api.RESTapi.root_resource_id # Use root resource
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [aws_api_gateway_integration.lambda_integration]
}

# Create Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.RESTapi.id

  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration_response.lambda_integration_response,
  ]
}

# Create Stage
resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.RESTapi.id
  stage_name    = var.stage_name
  tags = {
    Project = var.project_name
  }
}

# Add Lambda Permission for API Gateway
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloud-resume-func-but-terraformed.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.RESTapi.execution_arn}/*/*"
}
