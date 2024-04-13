provider "aws" {
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
  region              = var.region
}

#import existing DynamoDB to preserve content to the new one TF create
import {
  to = aws_dynamodb_table.cloud_resume_challenge_db
  id = "arn:aws:dynamodb:us-east-1:861150920151:table/cloud_resume_challenge_db"
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
    Name = "Cloud Resume Challenge"
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
          "Resource" : "arn:aws:logs:*:*:*",

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
}

## attach policy to newly created role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

