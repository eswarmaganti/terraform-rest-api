output "app_lb_dns_name" {
  value = aws_lb.app_elb.dns_name
}
output "app_lb_zone_id" {
  value = aws_lb.app_elb.zone_id
}