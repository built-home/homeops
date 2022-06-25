#!/usr/bin/env bash

ORGANIZATION=${ORGANIZATION:-built-home}
REPO_NAME=${REPO_NAME:-homeops}
REPO_BRANCH=${REPO_BRANCH:-master}
REPO_PATH=${REPO_PATH:-/clusters}


if [ -z "${GITHUB_TOKEN}" ]; then
    echo "set the GITHUB_TOKEN envvar to a Personal Access Token (PAT) of your account in order to bootstrap. This token will be used by flux to add a deploy key to the homeops repository"
    exit 1
fi


echo "bootstap homeops in flux-system namespace"
flux bootstrap github \
     --owner "${ORGANIZATION}" \
     --repository "${REPO_NAME}" \
     --branch "${REPO_BRANCH}" \
     --path "${REPO_PATH}" \
     --network-policy=false \
     --watch-all-namespaces=true \
     --namespace=flux-system