#!/usr/bin/env bash
set -euo pipefail


setup_kind() {
    kind create cluster --config ./kubernetes/kind/cluster.yaml
	kubectl apply -f ./kubernetes/kind/registry.yaml
}


bootstrap() {
    kubectl create secret generic cloudfare --from-literal=token=${CLOUDFARE}

    echo "Installing Flux"
    flux bootstrap github \
    	--owner=teaglebuilt \
     	--repository=homelab \
     	--branch=master \
     	--path=clusters/dev \
     	--network-policy=false \
     	--watch-all-namespaces=true \
		--namespace=flux-system \
		--personal
}



function help {
    printf "%s <task> [args]\n\nTasks:\n" "${0}"
    compgen -A function | grep -v "^_" | cat -n
}


"${@:-help}"