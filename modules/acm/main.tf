resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = var.domain_name
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for domain_name in [var.domain_name] :
    domain_name => {
      name = domain_name
    }
  }

  zone_id = var.hosted_zone_id
  name = one([
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.resource_record_name
    if dvo.domain_name == each.key
  ])
  type = one([
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.resource_record_type
    if dvo.domain_name == each.key
  ])
  ttl = 60
  records = [one([
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.resource_record_value
    if dvo.domain_name == each.key
  ])]
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn

  validation_record_fqdns = [
    for record in aws_route53_record.certificate_validation :
    record.fqdn
  ]
}
