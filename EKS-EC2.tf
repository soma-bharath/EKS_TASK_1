resource "aws_instance" "my_ec2" {
  instance_type   = "t2.micro"
  ami             = "ami-0b0dcb5067f052a63"
  subnet_id       = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name        = "TF"
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.rsa.private_key_pem
    host        = aws_instance.my_ec2.public_ip
  }

    provisioner "file" {
    source      = "${path.module}/TF.pem"
    destination = "/home/ec2-user/.ssh/TF.pem"
  }

    provisioner "file" {
    source      = "${path.module}/configHost"
    destination = "/home/ec2-user/.ssh/configHost"
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
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo docker pull python
sudo chmod 700 /home/ec2-user/.ssh/TF.pem
sudo cp ${path.module}/configHost ~/.ssh/
EOF
  tags = {
    Name = "EKS-EC2"
  }
}
