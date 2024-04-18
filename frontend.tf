resource "aws_s3_bucket" "cloud_resume_s3_static_host" {
    bucket = "terraform_s3_cloud_resume_bucket"
    acl = "publick-read"
    policy = jsonencode(var.s3_bucket_policy)

    cors_rule {
        allowed_headers = ["Authorization", "Content-Length"]
        allowed_methods = ["GET", "POST"]
        allowed_origins = ["*"]
        max_age_seconds = 10
    }

    website {
        index_document = "index.html"
    }

}
  