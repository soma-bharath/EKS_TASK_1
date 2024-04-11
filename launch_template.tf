resource "aws_launch_template" "example" {
  name_prefix   = "example-lt"

  key_name      = aws_key_pair.Node_key_pair.key_name

  #user_data = filebase64("${path.module}/kubesetup.sh")

security_group_names = [data.aws_security_group.EKS-Security-Group.name]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      volume_type = "gp2"
      delete_on_termination = true
      encrypted             = true
    }
  }

  block_device_mappings {
    device_name = "/dev/sdh"
    ebs {
      volume_size           = 50
      volume_type = "gp2"
      delete_on_termination = true
      encrypted             = true
    }
  }

   depends_on = [aws_eks_cluster.testekscluster]
}
