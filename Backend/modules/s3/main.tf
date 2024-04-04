resource "aws_s3_bucket" "serverless-application-bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_website_configuration" "static-website" {
  bucket = aws_s3_bucket.serverless-application-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "bucker-versioning" {
  bucket = aws_s3_bucket.serverless-application-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket-ownership" {
  bucket = aws_s3_bucket.serverless-application-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.serverless-application-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket-ownership,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.serverless-application-bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.serverless-application-bucket.id
  policy = <<EOF
{
	"Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
EOF
}

