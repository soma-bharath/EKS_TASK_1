#!/bin/bash
set -x
set -e
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
sudo rm -f argocd-linux-amd64
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
#password=$(sudo argocd admin initial-password -n argocd)
#echo "$password"
echo "Run cmd -- sudo argocd admin initial-password -n argocd and copy the displayed password"
echo -e "Next steps to do: \n 1. get the argocd elb url and login \n 2. Run --argocd login <ARGOCD_SERVER>-- \n 3. Run --argocd account update-password--"
