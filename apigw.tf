resource "aws_api_gateway_rest_api" "example" {

  body = file("./.rendered/swagger.json")
  name = "example"
  #description = "test api gateway"description"

  endpoint_configuration {
    types = ["PRIVATE"]
  }

  depends_on = [aws_api_gateway_vpc_link.example, aws_api_gateway_domain_name.example, local_file.swagger-api]
}


# Render the local_file with patched value
resource "local_file" "swagger-api" {

  content  = templatefile("./swagger.json.tmpl", 
                          {
                             VPCID = data.aws_api_gateway_vpc_link.example.example.id[0].data
                          }
  )
  
  filename = "./.rendered/swagger.json"

  depends_on = [aws_api_gateway_vpc_link.example]
}


resource "aws_api_gateway_rest_api_policy" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  policy = file("policy.json")

  depends_on = [aws_api_gateway_rest_api.example]
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.example.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_rest_api.example]
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "example"
}

resource "aws_api_gateway_vpc_link" "example" {
  name        = "example"
  description = "example description"
  target_arns = ["arn:aws:elasticloadbalancing:us-west-2:227453601360:loadbalancer/net/test-apigw/c79dd272300327c7"]
}

resource "aws_api_gateway_domain_name" "example" {
  domain_name              = "hansen-app-1.hansen-pi-dev.aws.dishcloud.io"
  regional_certificate_arn = "arn:aws:acm:us-west-2:227453601360:certificate/2c8e1921-1a1f-45c1-8f31-7a5c1adaa4b5"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  depends_on = [aws_api_gateway_vpc_link.example]
}


# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.

