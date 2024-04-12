resource "aws_instance" "my_ec2" {
  instance_type   = "t2.micro"
  ami             = "ami-0395649fbe870727e"
  #subnet_id       = aws_subnet.public_subnet_1.id
  subnet_ids             = [for s in data.aws_subnet.private_subnets : s.id]
  vpc_security_group_ids = [data.aws_security_group.EKS-Security-Group.id]
  key_name        = aws_key_pair.Node_key_pair.key_name
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.keypair.private_key_pem
    host        = aws_instance.my_ec2.public_ip
  }

    provisioner "file" {
    source      = "${path.module}/Node-key.pem"
    destination = "/home/ec2-user/.ssh/Node-key.pem"
  }

    provisioner "file" {
    source      = "${path.module}/configHost"
    destination = "/home/ec2-user/.ssh/configHost"
  }

    provisioner "file" {
    source      = "${path.module}/role.yaml"
    destination = "/home/ec2-user/role.yaml"
  }

  user_data = <<EOF
#!/bin/bash
set -x
cat <<EOFR | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
EOFR
sudo yum install -y kubectl
sudo chmod 700 /home/ec2-user/.ssh/TF.pem
sudo cp ${path.module}/configHost ~/.ssh/
EOF
  tags = {
    Name = "EKS-EC2"
  }
}
