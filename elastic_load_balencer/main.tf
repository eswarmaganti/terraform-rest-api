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

resource "aws_lb_listener" "webtier_lb_listener" {
  load_balancer_arn = aws_lb.app_elb.arn
  port              = var.app_http_listner_port
  protocol          = var.app_http_listner_protocol
  default_action {
    target_group_arn = var.app_tg_arn
    type             = "forward"
  }
}
