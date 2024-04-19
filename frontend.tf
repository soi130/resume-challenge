
#=================
#S3 Part
#=================
resource "aws_s3_bucket" "TerraformThanakcloudResumeS3StaticHost" {
  bucket = "terraform-thanak.net"
  tags = {
    Name = var.project_tag
  }
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
  bucket       = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
  count        = length(var.original_file_paths_for_s3)
  key          = basename(var.original_file_paths_for_s3[count.index])
  source       = var.original_file_paths_for_s3[count.index]
  content_type = "text/html"
  etag         = filemd5("${path.module}/Cloud Resume Challenge - Thanak - Front End/${basename(var.original_file_paths_for_s3[count.index])}")
}

#=================
#distribution part
#=================
resource "aws_acm_certificate" "ssl_cert" {
  domain_name       = "www.thanak.net"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.project_tag
  }
}

resource "aws_cloudfront_distribution" "terraform_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Comment - Create With Terraform for Cloud Resume Challenge"
  default_root_object = "index.html"

  aliases = ["www.thanak.net"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
    # cache_policy_id  = data.aws_cloudfront_cache_policy.terraform_cf_cache_policy.id
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600 #how long (in seconds) the data stays in CloudFront Cache
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.TerraformThanakcloudResumeS3StaticHost.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["TH", "CA", "AT", "SG"]
    }
  }

  tags = {
    Name = var.project_tag
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.ssl_cert.arn
    ssl_support_method  = "sni-only"

  }
}

#Invalidate CloudFront Cache
resource "null_resource" "terraform_s3_distribution_invalidation" {
  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.terraform_s3_distribution.id} --paths '/index.html'"
  }
  triggers = {
    website_version_changed = aws_s3_object.terraform_cloud_resume_s3_object[0].version_id
  }
}

#Invalidate CloudFront Cache
resource "null_resource" "terraform_s3_distribution_invalidation" {
  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.terraform_s3_distribution.id} --paths '/index.js'"
  }
  triggers = {
    website_version_changed = aws_s3_object.terraform_cloud_resume_s3_object[1].version_id
  }
}

#Invalidate CloudFront Cache
resource "null_resource" "terraform_s3_distribution_invalidation" {
  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.terraform_s3_distribution.id} --paths '/resume.css'"
  }
  triggers = {
    website_version_changed = aws_s3_object.terraform_cloud_resume_s3_object[2].version_id
  }
}
