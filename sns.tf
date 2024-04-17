
resource "aws_sns_topic" "EKS_SNS" {
  name = var.sns_name


  tags = {
    Name = "EKS-SNS"
    Date = local.current_date
    Env  = var.env
  }
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.EKS_SNS.arn
  protocol  = "email"
  endpoint  = var.email_address # Specify the email address for subscription
}
