resource "aws_launch_template" "example" {
  name_prefix   = "example-lt"

  key_name      = aws_key_pair.Node_key_pair.key_name

  user_data = filebase64("${path.module}/kubesetup.sh")
  
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }
   depends_on = [aws_eks_cluster.testekscluster]
}
