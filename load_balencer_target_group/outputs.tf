output "webtier_target_group_arn" {
  value = aws_lb_target_group.webtier_target_group.arn
}
output "webtier_target_group_id" {
  value = aws_lb_target_group.webtier_target_group.id
}

output "apptier_target_group_arn" {
  value = aws_lb_target_group.apptier_target_group.arn
}
output "apptier_target_group_id" {
  value = aws_lb_target_group.apptier_target_group.id
}
