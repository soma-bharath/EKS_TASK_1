terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"

}

resource "null_resource" "kubectl_setup" {
  provisioner "local-exec" {
    command = <<EOT
      sudo chmod 777 kubesetup.sh
      sudo bash ${path.module}/kubesetup.sh
      sudo kubectl -n kube-system set image deployment.apps/cluster-autoscaler cluster-autoscaler=us.gcr.io/k8s-artifacts-prod/autoscaling/cluster-autoscaler:v1.26.2
      sudo kubectl apply -f ${path.module}/cluster-autoscaler-autodiscover.yaml
      sudo kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
    EOT
  }
depends_on=[aws_eks_cluster.testekscluster,aws_eks_node_group.testeksclusternode]
}
