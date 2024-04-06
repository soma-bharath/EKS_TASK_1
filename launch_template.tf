resource "aws_launch_template" "example" {
  name_prefix   = "example-lt"
  image_id      = "ami-0395649fbe870727e"
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_role.Amazon_EKS_NodeRole.name
  }

  user_data = filebase64("${path.module}/kubesetup.sh")
  /*
  user_data = <<-EOF
              #!/bin/bash
              mkdir /home/ec2-user/localpath
              sudo yum update -y
              sudo yum install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              cat <<EOFR | sudo tee /etc/yum.repos.d/kubernetes.repo
              [kubernetes]
              name=Kubernetes
              baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
              enabled=1
              gpgcheck=1
              gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
              EOFR
              sudo yum install -y kubectl
              sudo aws eks --region us-west-2 update-kubeconfig --name test-eks-cluster
              kubectl create namespace kumar
              EOF
*/
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }
   depends_on = [aws_eks_cluster.testekscluster]
}
