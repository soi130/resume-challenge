resource "aws_s3_bucket" "cloud-resume-s3-static-host" {
  bucket = "terraform_s3_cloud_resume_bucket"

}

resource "aws_s3_bucket_website_configuration" "terraform_cloud_resume_s3_website_config" {
  bucket = aws_s3_bucket.cloud-resume-s3-static-host.id
  index_document {
    suffix = "index.html"
  }

}

resource "aws_s3_bucket_policy" "terraform_cloud_resume_s3_policy" {
  bucket = aws_s3_bucket.cloud-resume-s3-static-host.id
  policy = jsonencode(var.s3_bucket_policy)
}

resource "aws_s3_bucket_ownership_controls" "terraform_cloud_resume_s3_ownership_control" {
  bucket = aws_s3_bucket.cloud-resume-s3-static-host.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "terraform_cloud_resume_s3_acl" {
  bucket     = aws_s3_bucket.cloud-resume-s3-static-host.id
  depends_on = [aws_s3_bucket_ownership_controls.terraform_cloud_resume_s3_ownership_control]
  acl        = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "tf_cloud_resume_s3_cors" {
  bucket = aws_s3_bucket.cloud-resume-s3-static-host.id
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 10
  }


}
  