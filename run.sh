#!/usr/bin/env bash


flux_install() {
  fluxctl install \
        --namespace flux \
        --git-url git@https://github.com/teaglebuilt/octoflow.git \
        --git-email dillan.teagle.va@gmail.com  | kubectl apply -f -
}

install_cluster() {
  k3d cluster create rancher \
    --api-port 6550 --servers 1 --agents 1 \
    --k3s-arg "--disable=traefik@server:0" \
    --port "80:80@loadbalancer" --port "443:443@loadbalancer" \
    --api-port 0.0.0.0:6550
  echo "setup certmanager"
}


install_rancher() {
  cert_manager_version="v1.3.1"
  echo "deploying certmanager to cluster"
  kubectl create namespace cert-manager
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml

  helm install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --leader-elect=false \
    --version ${cert_manager_version} --wait

  kubectl -n cert-manager rollout status deploy/cert-manager

  echo "deploying rancher to cluster"
  kubectl create namespace cattle-system
  helm install rancher rancher-latest/rancher \
    --namespace cattle-system \
    --set hostname=rancher.k3d.localhost
  kubectl -n cattle-system rollout status deploy/rancher
}

install_nginx() {
  helm repo add nginx-stable https://helm.nginx.com/stable
  helm repo update
  helm install nginx-ingress nginx-stable/nginx-ingress
}



function help {
    printf "%s <task> [args]\n\nTasks:\n" "${0}"
    compgen -A function | grep -v "^_" | cat -n
}


"${@:-help}"