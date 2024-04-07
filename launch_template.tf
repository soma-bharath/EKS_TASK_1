resource "aws_launch_template" "example" {
  name_prefix   = "example-lt"
  image_id      = "ami-0395649fbe870727e"
  instance_type = "t2.micro"

  #user_data = filebase64("${path.module}/kubesetup.sh")

  user_data = base64encode(templatefile("kubesetup.tpl", { CLUSTER_NAME = aws_eks_cluster.testekscluster.name, B64_CLUSTER_CA = aws_eks_cluster.testekscluster.certificate_authority[0].data, API_SERVER_URL = aws_eks_cluster.testekscluster.endpoint }))
  
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }
   depends_on = [aws_eks_cluster.testekscluster]
}
