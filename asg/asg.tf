

resource "aws_launch_template" "webdb_template" {
  name = "web-db-ASG-template"
  iam_instance_profile {
    arn = data.aws_iam_instance_profile.wdb.arn
  }
  # block_device_mappings {
  #   device_name = "/dev/sda1"

  #   ebs {
  #     volume_size           = 8
  #     delete_on_termination = true
  #     volume_type           = "gp3"
  #   }
  # }

  image_id               = data.aws_ami.webdb_ami.id
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.web_server_db.id]

}


resource "aws_autoscaling_group" "webserver_asg" {
  name                      = "webserver-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = [data.aws_subnet.public.id, data.aws_subnet.public1.id]
  target_group_arns         = [aws_lb_target_group.webserver_tg.arn]
  launch_template {
    id      = aws_launch_template.webdb_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-server-${timestamp()}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_asg_policy_scaleup" {
  name                   = "web-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_web_scaleup" {
  alarm_name          = "cpu-alarm-web"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 60
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webserver_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.web_asg_policy_scaleup.arn]
}

resource "aws_autoscaling_policy" "web_asg_policy_scaledown" {
  name                   = "web-asg-policy-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_web_scaledown" {
  alarm_name          = "cpu-alarm-web-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webserver_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.web_asg_policy_scaledown.arn]
}

