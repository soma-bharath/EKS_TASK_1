
resource "aws_ssm_document" "shell_script" {
  name          = "shell_script_document"
  document_type = "Command"
  content = templatefile("${path.module}/script_template.json", {
    script_path = "${path.module}/kubesetup.sh"
  })
}

resource "aws_ssm_association" "execute_script" {
  name = "execute_script_association"
  targets {
    key    = "tag: Name"
    values = ["test-eks-nodegroup-1"]    # ["eks-node-group"] 
  }
  document_version = "$LATEST"
  parameters       = {}
  association_name = "execute_script_association"
  wait_for_success_timeout_seconds = 600
}
