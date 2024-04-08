resource "aws_eks_node_group" "testeksclusternode" {

  ami_type               = "AL2_x86_64"
  capacity_type          = "ON_DEMAND"
  cluster_name           = aws_eks_cluster.testekscluster.name
  disk_size              = 20
  force_update_version   = null
  instance_types         = ["t2.micro"]
  labels                 = {}
  node_group_name        = "test-eks-nodegroup-1"
  node_group_name_prefix = null
  node_role_arn          = aws_iam_role.Amazon_EKS_NodeRole.arn
  release_version        = "1.28.1-20231002"
  subnet_ids             = [for s in data.aws_subnet.private_subnets : s.id]
  tags = {
    Name = "test-eks-nodegroup-1"
  }
  tags_all = {
    Name = "test-eks-nodegroup-1"
  }
  version = "1.28"
  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 2
  }
  update_config {
    max_unavailable = 1
  }
  depends_on = [aws_eks_cluster.testekscluster]
}
