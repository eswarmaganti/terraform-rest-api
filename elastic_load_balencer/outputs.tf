output "webtier_lb_public_dns" {
  value = aws_lb.app_elb.dns_name
}
