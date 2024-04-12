provider "aws" {
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
  region = var.region
}

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

# resource "aws_dynamodb_table_item" "cloud_resume_challenge_db" {
#   table_name = aws_dynamodb_table.cloud_resume_challenge_db.name
#   hash_key   = aws_dynamodb_table.cloud_resume_challenge_db.hash_key
#   item = <<ITEM
#   {
#     "id":{"N":1"}
#   }
#   ITEM
# }

