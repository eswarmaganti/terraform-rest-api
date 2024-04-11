
resource "aws_route53_record" "route53" {
  zone_id = var.aws_hosted_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.aws_lb_dns_name
    zone_id                = var.aws_lb_zone_id
    evaluate_target_health = true
  }
}
