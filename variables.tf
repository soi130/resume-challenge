variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "tfc_aws_dynamic_credentials" {
  description = "Object containing AWS dynamic credentials configuration"
  type = object({
    default = object({
      shared_config_file = string
    })
    aliases = map(object({
      shared_config_file = string
    }))
  })
}

variable "s3_bucket_name" {
  description = "Terraform S3 Name for static web hosting"
  default     = "terraform-thanak.net"
}

variable "s3_bucket_policy" {
  description = "S3 public access policy"
  default = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::terraform-thanak.net/*"
      }
    ]
  })
}