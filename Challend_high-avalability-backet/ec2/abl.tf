resource "aws_lb" "alb" {
  name = "webAlb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.web.id]
  subnets = values(var.public_subnet_map)

  enable_deletion_protection = false

  tags = {
    Name = "webAlb"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type =  "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_validate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

variable "public_subnet_map" {
  description = "map of Public subnet id's"
  type = map(string)
}

variable "cert_validate_arn" {
  type = string
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}