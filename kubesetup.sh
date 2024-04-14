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
kubectl create namespace kumar
sudo kubectl apply -f cluster-autoscalar-autodiscover.yaml
sudo kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
