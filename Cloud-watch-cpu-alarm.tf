resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "eks_worker_nodes_cpu_utilization_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when CPU utilization exceeds 80% on EKS worker nodes"
  dimensions = {
    cluste-name = aws_eks_cluster.testekscluster.name
  }
  alarm_actions = [aws_sns_topic.EKS_SNS.arn]

  tags = {
    Name = "eks_worker_nodes_cpu_utilization_alarm"
    Date = local.current_date
    Env  = var.env
  }
}
