resource "aws_lb" "app_elb" {
  name               = var.app_lb_name
  internal           = var.internal
  load_balancer_type = var.app_lb_type
  security_groups    = var.app_sg_ids
  subnets            = var.public_subnet_ids
  tags = {
    Name = "Application Load Balencer"
  }
}

resource "aws_lb_listener" "app_lb_http_listener" {
  load_balancer_arn = aws_lb.app_elb.arn
  port              = var.app_http_listner_port
  protocol          = var.app_http_listner_protocol
  default_action {
    target_group_arn = var.app_tg_arn
    type             = "forward"
  }
}
resource "aws_lb_listener" "app_lb_https_listener" {
  load_balancer_arn = aws_lb.app_elb.arn
  port              = var.app_https_listner_port
  protocol          = var.app_https_listner_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn = var.ssl_certificate_arn
  default_action {
    target_group_arn = var.app_tg_arn
    type             = "forward"
  }
}
