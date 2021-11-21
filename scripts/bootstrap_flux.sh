#!/usr/bin/env bash

REPO_OWNER=${REPO_OWNER:-teaglebuilt}
REPO_NAME=${REPO_NAME:-homelab}
REPO_BRANCH=${REPO_BRANCH:-master}
REPO_PATH=${REPO_PATH:-kubernetes/clusters/dev}


if [ -z "${GITHUB_TOKEN}" ]; then
    echo "set the GITHUB_TOKEN envvar to a Personal Access Token (PAT) of your account in order to bootstrap. This token will be used by flux to add a deploy key to the homeops repository"
    exit 1
fi


echo "bootstap homeops in flux-system namespace"
flux bootstrap github \
     --owner "${REPO_OWNER}" \
     --repository "${REPO_NAME}" \
     --branch "${REPO_BRANCH}" \
     --path "${REPO_PATH}" \
     --network-policy=false \
     --watch-all-namespaces=true \
     --namespace=flux-system \
     --personal