#!/usr/bin/env bash
set -euo pipefail

image_tag="${1:?Usage: bash k8s-deploy.sh IMAGE_TAG}"
if [[ ! "$image_tag" =~ ^[a-zA-Z0-9_][a-zA-Z0-9_.-]{0,127}$ ]]; then
    echo "Invalid Docker image tag: $image_tag" >&2
    exit 1
fi

context="${KUBE_CONTEXT:-kind-skillcheck-project}"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

sed \
    -e "s|image: dddominik/sc-backend:.*|image: dddominik/sc-backend:$image_tag|" \
    -e "s|image: dddominik/sc-frontend:.*|image: dddominik/sc-frontend:$image_tag|" \
    "$script_dir/deployment.yaml" |
    kubectl --context "$context" apply -f -

kubectl --context "$context" rollout status deployment/backend --timeout=180s
kubectl --context "$context" rollout status deployment/frontend --timeout=180s