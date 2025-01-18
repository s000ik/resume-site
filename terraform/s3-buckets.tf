# Create S3 bucket for website hosting
resource "aws_s3_bucket" "website" {
  bucket = var.website_bucket_name

  tags = {
    Project = var.project_name
  }
}

# Configure website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  depends_on = [aws_s3_bucket.website]
}

# Configure Object Ownership
resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [aws_s3_bucket.website]
}

# Configure public access block
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on = [aws_s3_bucket.website]
}


# Add bucket policy for CloudFront access
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  # Only allowing CloudFront to access the bucket with just READ permission
  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" =  aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket.website, aws_cloudfront_distribution.website] # Because I need the CloudFront distribution ARN
}

# Upload website files
resource "aws_s3_object" "website_files" {
  for_each = fileset("../website/", "**/*")

  bucket = aws_s3_bucket.website.id
  key    = each.value
  source = "../website/${each.value}"
  etag   = filemd5("../website/${each.value}")
  content_type = lookup({
    "html"  = "text/html",
    "css"   = "text/css",
    "js"    = "application/javascript",
    "png"   = "image/png",
    "jpg"   = "image/jpeg",
    "jpeg"  = "image/jpeg",
    "ico"   = "image/x-icon"
    "woff"  = "font/woff",
    "woff2" = "font/woff2",
    "svg"   = "image/svg+xml"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "binary/octet-stream")

  depends_on = [aws_s3_bucket.website]
}
