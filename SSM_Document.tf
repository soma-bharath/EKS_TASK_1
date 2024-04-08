data "template_file" "shell_script_content" {
  template = file("${path.module}/kubesetup.sh")
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
          "shellScript": "${data.template_file.shell_script_content.rendered}"
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
