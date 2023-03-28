resource "aws_lb" "lb" {
  name     = var.lb_name
  internal = false
  subnets  = aws_subnet.the_real_subnet.*.id
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "lb-target-group"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_vpc.example.id
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "8000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}