output "website_url"{
    value = "http://${aws_s3_bucket_website_configuration.static-website.website_endpoint}"
    description = "Website endpoint"
}
