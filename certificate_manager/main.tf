resource "aws_acm_certificate" "app_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags = {
    Name = "Application Certificate"
  }
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dov in aws_acm_certificate.app_certificate.domain_validation_options : dov.domain_name => {
      name   = dov.resource_record_name
      record = dov.resource_record_value
      type   = dov.resource_record_type
    }
  }
  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}
