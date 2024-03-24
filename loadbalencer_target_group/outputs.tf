output "app_tg_arn" {
  value = aws_lb_target_group.webtier_target_group.arn
}
output "app_tg_id" {
  value = aws_lb_target_group.webtier_target_group.id
}
