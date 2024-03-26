
resource "aws_sqs_queue" "my_queue" {
  name                       = var.sqs_name
  delay_seconds              = 90
  max_message_size           = 2048
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 30
  receive_wait_time_seconds  = 10
}


resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.EKS_SNS.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.my_queue.arn
}
