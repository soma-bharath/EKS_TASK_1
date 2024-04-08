
# Define your shell script content
variable "shell_script_content" {
  default = <<-EOT
#!/bin/bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
EOF
sudo yum install -y kubectl
sudo aws eks --region us-west-2 update-kubeconfig --name test-eks-cluster
sudo kubectl create namespace kumar
EOT
}

# Create an SSM document for the shell script
resource "aws_ssm_document" "shell_script" {
  name          = "RunShellScript"
  document_type = "Command"
  content = <<-EOF
{
  "schemaVersion": "1.0",
  "description": "Runs a shell script",
  "runtimeConfig": {
    "aws:runShellScript": {
      "properties": [
        {
          "id": "0.aws:runShellScript",
          "shellScript": "${var.shell_script_content}"
        }
      ]
    }
  }
}
EOF
}

# Create an association to execute the shell script
resource "aws_ssm_association" "shell_script_association" {
  name          = "run-shell-script"
    targets {
    key    = "tag: Name"
    values = ["test-eks-nodegroup-1"]    # ["eks-node-group"] 
  }
  document_version = "$LATEST"
}
