#!/usr/bin/env bash
set -euo pipefail


decrypt() {
    if [ -n "${1-}" ]; then
        echo "decrypting ${1}.yaml"
        sops -d -i "${@}".yaml
    else
        sops -d -i secrets/secrets.yaml
    fi
}


encrypt() {
    if [ -n "${1-}" ]; then
        echo "encrypting ${1}.yaml"
        sops -e -i "${@}".yaml
    else
        sops -e -i secrets/secrets.yaml
    fi
}


bootstrap() {
    kubectl create namespace flux-system
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