# Target Group for ASG
resource "aws_lb_target_group" "webtier_target_group" {
  name     = "webtier-lb-target-group"
  port     = var.app_tg_port
  vpc_id   = var.vpc_id
  protocol = var.app_tg_protocol
  health_check {
    interval            = 70
    path                = "/"
    port                = var.app_tg_port
    healthy_threshold   = 4
    unhealthy_threshold = 2
    timeout             = 60
    protocol            = var.app_tg_protocol
    matcher             = "200,202"
  }
}
