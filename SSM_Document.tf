resource "aws_ssm_document" "shell_script" {
  name          = "shell_script_document"
  document_type = "Command"
  content = <<DOC
{
  "schemaVersion": "2.2",
  "description": "Run a shell script",
  "parameters": {},
  "runtimeConfig": {
    "aws:runShellScript": {
      "properties": [
        {
          "id": "0.aws:runShellScript",
          "runCommand": ["your_script.sh"]
        }
      ]
    }
  }
}
DOC
}

resource "aws_ssm_association" "execute_script" {
  name = "execute_script_association"
  targets {
    key    = "tag:eks-node-group"
    values = ["eks-node-group"]  # Replace with the name of your EKS node group
  }
  document_version = "$LATEST"
  parameters       = {}
  association_name = "execute_script_association"
  wait_for_success_timeout_seconds = 600
}
