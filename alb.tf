resource "aws_lb" "alb-tf" {
  name               = "portfolio-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [module.vpc.public_subnets[0],module.vpc.public_subnets[1]]

  enable_deletion_protection = false

  tags = {
    Environment = "demo"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb-tf.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.alb-tf.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-south-1:361769588144:certificate/588157e1-0490-445e-812e-2fa988843403"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response message"
      status_code  = "200"
    }
  }
}
