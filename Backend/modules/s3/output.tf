output "website_url" {
value =  "http://${aws_s3_bucket.serverless-application-bucket.bucket}.s3-website.${var.region}.amazonaws.com"
}
