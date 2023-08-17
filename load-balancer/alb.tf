
resource "aws_lb" "webdb_lb" {
  # checkov:skip=BC_AWS_NETWORKING_58: ADD REASON
  # depends_on                 = [aws_s3_bucket.elb_logs]
  name                       = "webdb-lb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [data.aws_subnet.public.id, data.aws_subnet.public1.id]
  security_groups            = [data.aws_security_group.lb_sg.id]
  enable_deletion_protection = false
  drop_invalid_header_fields = true
  # access_logs {
  #   bucket  = aws_s3_bucket.elb_logs.id
  #   prefix  = "elblogs"
  #   enabled = true
  # }

}

resource "time_sleep" "wait_180_seconds" {
  depends_on = [aws_route53_record.lb_validate]

  create_duration = "180s"
}

resource "aws_lb_listener" "front_end" {
  depends_on        = [time_sleep.wait_180_seconds]
  load_balancer_arn = aws_lb.webdb_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.mig_cert.arn

  # default_action {
  #   type = "fixed-response"

  #   fixed_response {
  #     content_type = "text/plain"
  #     message_body = "Fixed response content"
  #     status_code  = "200"
  #   }
  # }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }

}

resource "aws_lb_listener" "redirect_front_end" {
  load_balancer_arn = aws_lb.webdb_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
      host        = "www.sathyaraj.aws.crlabs.cloud"
      path        = "/"
      query       = ""
    }
  }
}



resource "aws_lb_target_group" "webserver_tg" {
  name        = "web-server-db-asg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.web_db.id
  health_check {
    path     = "/"
    port     = 80
    protocol = "HTTP"

  }
}

# resource "aws_lb_target_group_attachment" "migrated_ec2_attcah" {
#   target_group_arn = aws_lb_target_group.migrated_webserver.arn
#   target_id        = data.aws_instance.ec2.id
  
#   port             = 80
# }
# resource "aws_route53_record" "alb_r53" {
#   zone_id = data.aws_route53_zone.myzone.zone_id
#   name    = "www.capci-gp4.aws.crlabs.cloud"
#   type    = "CNAME"
#   ttl     = 300
#   records = [aws_lb.webdb_lb.dns_name]
# }

resource "aws_route53_record" "aliaslb" {
  zone_id = aws_route53_zone.public_member.zone_id
  name    = "*.sathyaraj.aws.crlabs.cloud"
  type    = "A"

  alias {
    name                   = aws_lb.webdb_lb.dns_name
    zone_id                = aws_lb.webdb_lb.zone_id
    evaluate_target_health = true
  }
}
