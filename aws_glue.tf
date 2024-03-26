resource "aws_glue_catalog_database" "example"{
name= "example"
}

resource "aws_glue_job" "example" {
  name     = "example"
  role_arn = aws_iam_role.glue_role.arn
  command {
    name            = "glueetl"
    script_location = "s3://ekss3bucket102989/one.py" # Change this to your script location
  }
depends_on = [aws_iam_role_policy_attachment.glue_policy_attachment]
}

resource "aws_glue_workflow" "example"{
name= "example"
}
# Create Glue Trigger as Schedule
resource "aws_glue_trigger" "example" {
  name          = "example_glue_trigger"
  type          = "ON_DEMAND"
  workflow_name = aws_glue_job.example.name
  actions {
    job_name = aws_glue_job.example.name
  }
}
