
module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"

  name  = "test-sns"

  subscriptions = {
    sqs = {
      protocol = "email"
      endpoint = "nareshupwork3@gmail.com"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

data "aws_instance" "test" {
  filter {
    name   = "tag:Name"
    values = ["test_instance"]
  }
}  

module "metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"

  alarm_name          = "cpu_utilization"
  alarm_description   = "Alarm when CPU utilization is greater than or equal to 80%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 80
  period              = 300
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"
  dimensions = {
    instance_id = data.aws_instance.test.id
  }
  alarm_actions = [module.sns_topic.topic_arn]
}
