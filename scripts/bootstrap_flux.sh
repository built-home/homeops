#!/usr/bin/env bash

ORGANIZATION=${ORGANIZATION:-built-home}
REPO_NAME=${REPO_NAME:-homeops}
REPO_BRANCH=${REPO_BRANCH:-master}
REPO_PATH=${REPO_PATH:-/clusters}


if [ -z "${GITHUB_TOKEN}" ]; then
    echo "set the GITHUB_TOKEN envvar to a Personal Access Token (PAT) of your account in order to bootstrap. This token will be used by flux to add a deploy key to the homeops repository"
    exit 1
fi


_install_flux() {
    echo "bootstap homeops in flux-system namespace"
    flux bootstrap github \
        --owner "${ORGANIZATION}" \
        --repository "${REPO_NAME}" \
        --branch "${REPO_BRANCH}" \
        --path "${REPO_PATH}" \
        --network-policy=false \
        --watch-all-namespaces=true \
        --namespace=flux-system
}


_setup_crds {
    echo "installing certmanager CRD's, needs to be removed."
    kubectl apply -f \
        https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml
}

_setup_secrets {
    echo "setting up cluster secret encryption"
    gpg --export-secret-keys --armor \
        ${GPG_FINGERPRINT} | kubectl create secret generic sops-gpg } \
            --namespace=flux-system --from-file=sops.asc=/dev/stdin

    kubectl create secret generic actions-runner-controller-auth \
        --from-literal=github_app_id=${GITHUB_APP_ID} \
        --from-literal=github_app_installation_id=${GITHUB_INSTALLATION_ID} \
        --from-literal=github_app_private_key=${GITHUB_PRIVATE_KEY}

    TOKEN=$(head -c 12 /dev/urandom | shasum | cut -d ' ' -f1)
    echo "generated homeops receiver token: $TOKEN"
    kubectl -n flux-system create secret generic webhook-token \	
        --from-literal=token=$TOKEN
}

function setup_flux() {
    _install_flux
    _setup_secrets
    _setup_crds
}