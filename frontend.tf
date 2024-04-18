resource "aws_s3_bucket" "TerraformThanakcloudResumeS3StaticHost" {
  bucket = "terraform-thanak.net"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "terraform_cloud_resume_s3_policy_config" {
  bucket = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
  policy = jsonencode(var.s3_bucket_policy)
}

resource "aws_s3_bucket_website_configuration" "terraform_cloud_resume_s3_website_config" {
  bucket = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "terraform_cloud_resume_s3_versioning_config" {
  bucket = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "terraform_cloud_resume_s3_ownership_control" {
  bucket = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_cors_configuration" "terraform_cloud_resume_s3_cors" {
  bucket = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 10
  }
}

#iterate over multiple files with count 
resource "aws_s3_object" "terraform_cloud_resume_s3_object" {
  bucket        = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
  count         = length(var.original_file_paths_for_s3)
  key           = "${basename(var.original_file_paths_for_s3[count.index])}"
  source        = var.original_file_paths_for_s3[count.index]
  content_type = "text/html"
  etag          = filemd5("${path.module}/Cloud Resume Challenge - Thanak - Front End/${basename(var.original_file_paths_for_s3[count.index])}")
}

  