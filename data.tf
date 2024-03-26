data "aws_vpc" "main_vpc"{

  filter {
    name=tag:Name"
    values=["main-vpc"]
  }
}

data "aws_subnets" "private"{
  filter {
    name="vpc-id"
    values=[data.aws_vpc.main_vpc.id]
  }
  filter {
    name="tag:Subnet-Type"
    values=["private"]
  }
}

data "aws_subnet" "private_subnets"{
  for_each=toset(data.aws_subnets.private.ids)
  id = each.value
}

data "aws_security_group" "EKS-Security-Group"{
  name = "EKS-Security-Group"
}
