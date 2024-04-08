resource "aws_ssm_document" "document" {
  name          = "test_document"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Check ip configuration of a Linux instance.",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["#!/bin/bash","cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo","[kubernetes]","name=Kubernetes","baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/","enabled=1","gpgcheck=1","gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key","EOF","sudo yum install -y kubectl","sudo yum install -y docker","sudo systemctl start docker","sudo systemctl enable docker","sudo docker pull python"]
          }
        ]
      }
    }
  }
DOC
}

resource "aws_ssm_association" "associate"{
name = aws_ssm_document.document.name
targets {
    key    = "tag: Name"
    values = ["test-eks-nodegroup-1"]
}

}
