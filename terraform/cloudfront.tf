# CloudFront Origin Access Control, preventing direct access to S3
resource "aws_cloudfront_origin_access_control" "myOAC" {
  name                              = "CloudFront OAC for ${var.website_bucket_name}"
  description                       = "Cloud Resume OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"

}

# CloudFront Distribution, to serve the website
resource "aws_cloudfront_distribution" "website" {

  # Origin configuration
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.website.id
    origin_access_control_id = aws_cloudfront_origin_access_control.myOAC.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_All" # maybe worth it vs priceclass 100-200


  # Default cache behavior
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.website.id
    viewer_protocol_policy = "redirect-to-https"                    # I dont think HTTPS only is required
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized, picked from AWS docs
    compress               = true                                   # Compress objects automatically, would help with speed
  }

  # Custom domain name
  aliases = ["terraformed-resume.ssatwik.click"]

  # SSL certificate
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn # ACM certificate
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Project = var.project_name
  }

  depends_on = [
    aws_s3_bucket.website, # Because the bucket needs to be created first
    aws_cloudfront_origin_access_control.myOAC # Because the OAC needs to be created first
  ]
}

