
resource "aws_ecr_repository" "my_repository" {
  name = "my-ecr-repository"
  tags = {
    Name = "my-ecr-repository"
    Date = local.current_date
    Env  = var.env
  }
}
