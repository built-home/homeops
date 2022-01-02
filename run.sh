#!/usr/bin/env bash
set -euo pipefail


setup_kind() {
    kind create cluster --config ./kubernetes/kind/kind.yaml
	kubectl apply -f ./kubernetes/kind/registry.yaml
}


bootstrap() {
    # kubectl create secret generic cloudfare --from-literal=token=${CLOUDFARE}

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

playbook() {
  echo "running playbook ${1}"
  ansible-playbook -i ansible/inventory.ini \
    --extra-vars \
    "ansible_user=${ANSIBLE_USER} \
    ansible_password=${ANSIBLE_PASS}" \
    ansible/${1}.yaml
}


function help {
    printf "%s <task> [args]\n\nTasks:\n" "${0}"
    compgen -A function | grep -v "^_" | cat -n
}


"${@:-help}"