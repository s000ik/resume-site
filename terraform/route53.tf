# Using my existing Route53 zone
data "aws_route53_zone" "main" {
  name = "ssatwik.click"
  private_zone = false
}


resource "aws_route53_record" "resume" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "terraformed-resume.ssatwik.click"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}