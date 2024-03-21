output "webtier_asg_id" {
  value = aws_autoscaling_group.webtier-asg.id
}
output "webtier_asg_arn" {
  value = aws_autoscaling_group.webtier-asg.arn
}
output "apptier_asg_id" {
  value = aws_autoscaling_group.apptier-asg.id
}
output "apptier_asg_arn" {
  value = aws_autoscaling_group.apptier-asg.arn
}


