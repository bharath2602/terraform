resource "aws_lb" "task_alb" {
  name               = "task-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ElbSG.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "task_alb"
  }
}

resource "aws_lb_target_group" "task_tg" {
  name     = "task-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.task_vpc.id
}

resource "aws_lb_listener" "task_alb_listner" {
  load_balancer_arn = aws_lb.task_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.task_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "task_tg_attachment" {
  count            = length(aws_instance.task_server)
  target_group_arn = aws_lb_target_group.task_tg.arn
  target_id        = aws_instance.task_server[count.index].id
  port             = 80
}