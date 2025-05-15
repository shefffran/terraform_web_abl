resource "aws_lb_target_group" "alb_tg" {
  name = "albTg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.alb_tg_vpc_id
  target_type = "instance"

}

//attaching tg intance 1
resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id = aws_instance.ec2_instance[0].id
  port = 80
}

//attaching tg intance 2 
resource "aws_lb_target_group_attachment" "alb_tg_attachment_2" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id = aws_instance.ec2_instance[1].id
  port = 80
}

variable "alb_tg_vpc_id" {
  type = string
}

