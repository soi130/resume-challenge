#import existing DynamoDB to preserve content to the new one TF create
import {
  to = aws_dynamodb_table.cloud_resume_challenge_db
  id = aws_dynamodb_table.cloud_resume_challenge_db.arn
}

resource "aws_dynamodb_table" "cloud_resume_challenge_db" {
  name           = "cloud_resume_challenge_db"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name = var.project_tag
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "terraform_lambda_func_role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
  tags = {
    Name = var.project_tag
  }
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_lambda_func_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",

      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "*",

        },
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:UpdateItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem"
          ],
          "Resource" : aws_dynamodb_table.cloud_resume_challenge_db.arn
        },
      ]
    }
  )
  tags = {
    Name = var.project_tag
  }
}

## attach policy to newly created role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

#define
data "archive_file" "zip_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function"
  output_path = "${path.module}/lambda_function/lambda_function.zip"
}

#construct the actual lambda function
resource "aws_lambda_function" "terraform_lambda_write_to_dyndb" {
  filename         = data.archive_file.zip_python_code.output_path
  function_name    = "terraform_lambda_write_to_dyndb"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.zip_python_code.output_base64sha256
  runtime          = "python3.8"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  environment {
    variables = {
      databaseName = aws_dynamodb_table.cloud_resume_challenge_db.name
    }
  }
  tags = {
    Name = var.project_tag
  }
}

#create Cloudwatch Log group and API Gateway

resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "terraform_visitor_count_log_group"
  retention_in_days = 30
}

resource "aws_apigatewayv2_api" "api_gateway_for_lambda" {
  name          = "terraform_visitor_count_api_gateway"
  protocol_type = "HTTP"
  description   = "terraform API Gateway to trigger Lambda function to update visitor count"
  cors_configuration {
    allow_origins = ["https://www.thanak.net", "http://terraform-thanak.net.s3-website-us-east-1.amazonaws.com"]
    allow_methods = ["GET", "OPTIONS"]
  }
  tags = {
    Name = var.project_tag
  }

}


#set up stage of API Gateway to "Default" with enabling auto-deployment and config access log
resource "aws_apigatewayv2_stage" "default_api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway_for_lambda.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode({
      httpMethod              = "$context.httpMethod"
      integrationErrorMessage = "$context.integrationErrorMessage"
      protocol                = "$context.protocol"
      requestId               = "$context.requestId"
      requestTime             = "$context.requestTime"
      resourcePath            = "$context.resourcePath"
      responseLength          = "$context.responseLength"
      routeKey                = "$context.routeKey"
      sourceIp                = "$context.identity.sourceIp"
      status                  = "$context.status"
    })
  }
  tags = {
    Name = var.project_tag
  }
}

#Connect API Gateway with Lambda Function
resource "aws_apigatewayv2_integration" "integrated_lambda_function" {
  api_id             = aws_apigatewayv2_api.api_gateway_for_lambda.id
  integration_uri    = aws_lambda_function.terraform_lambda_write_to_dyndb.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"

}

#construct API Route
resource "aws_apigatewayv2_route" "terraform_lambda_api_gw_route" {
  api_id    = aws_apigatewayv2_api.api_gateway_for_lambda.id
  route_key = "GET /terraform_lambda_write_to_dyndb"
  target    = "integrations/${aws_apigatewayv2_integration.integrated_lambda_function.id}"

}

# Add permission for gateway to access lambda function
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_write_to_dyndb.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway_for_lambda.execution_arn}/*/*/terraform_lambda_write_to_dyndb"
}

#test distribution




