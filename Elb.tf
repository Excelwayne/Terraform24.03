# Create an Elastic Load Balancer (ELB)

resource "aws_alb" "xcel-elb" {
  name               = "xcel-elb"
  subnets            = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id]
  security_groups    = [aws_security_group.my_security_group.id, aws_security_group.allow_ssh.id]
  load_balancer_type = "application"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

resource "aws_alb_target_group" "elb_tg" {
  name     = "elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.xcelvpc.id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "elb_listener" {
  load_balancer_arn = aws_alb.xcel-elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.elb_tg.arn
    type             = "forward"
  }
}

resource "aws_autoscaling_attachment" "nf" {
  autoscaling_group_name = aws_autoscaling_group.xl_asg.id
  alb_target_group_arn   = aws_alb_target_group.elb_tg.arn
}
