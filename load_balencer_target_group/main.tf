
# Setup the load balencer target groups for webtier
resource "aws_lb_target_group" "webtier_target_group" {
  name     = var.webtier_target_group_name
  vpc_id   = var.vpc_id
  protocol = "TCP"
  port     = var.webtier_target_group_port

  health_check {
    port                = var.webtier_target_group_port
    path                = "/"
    interval            = 30
    timeout             = 2
    healthy_threshold   = 3
    unhealthy_threshold = 5
    matcher             = "200"
  }

}

# Attaching the target group to webtier instances
resource "aws_autoscaling_attachment" "asg_webtier_attachment" {
  autoscaling_group_name = var.webtier_asg_id
  lb_target_group_arn    = aws_lb_target_group.webtier_target_group.arn
}


# Setup the load balencer target groups for apptier
resource "aws_lb_target_group" "apptier_target_group" {
  name     = var.apptier_target_group_name
  vpc_id   = var.vpc_id
  protocol = "TCP"
  port     = var.apptier_target_group_port

  health_check {
    port                = var.apptier_target_group_port
    path                = "/"
    interval            = 30
    timeout             = 2
    healthy_threshold   = 3
    unhealthy_threshold = 5
    matcher             = "200"
  }

}

# Attaching the target group to webtier instances
resource "aws_autoscaling_attachment" "asg_apptier_attachment" {
  autoscaling_group_name = var.apptier_asg_id
  lb_target_group_arn    = aws_lb_target_group.apptier_target_group.arn
}
