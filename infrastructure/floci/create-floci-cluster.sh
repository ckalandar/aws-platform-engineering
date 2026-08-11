#!/usr/bin/env bash
# --------------------------------------------------------------------------
# create-floci-cluster.sh
#
# Creates a local K3s cluster with a container registry, emulating an EKS
# environment for local development ("floci" = "Fake Local OCI" / local EKS).
#
# Usage: ./create-floci-cluster.sh
#
# Prerequisites: Docker Desktop running on macOS.
# After creation, get the kubeconfig:
#   docker cp floci-eks-kk-platform-dev:/etc/rancher/k3s/k3s.yaml \
#     ./k3s-kubeconfig.yaml
#   sed -i '' "s/127.0.0.1/localhost/g; s/6443/6504/g" k3s-kubeconfig.yaml
#   export KUBECONFIG=$PWD/k3s-kubeconfig.yaml
# --------------------------------------------------------------------------
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLUSTER_NAME="${FLOCI_CLUSTER_NAME:-floci-eks-kk-platform-dev}"
REGISTRY_NAME="${FLOCI_REGISTRY_NAME:-floci-ecr-registry}"
NETWORK_NAME="${FLOCI_NETWORK:-floci-net}"
K3S_IMAGE="${FLOCI_K3S_IMAGE:-rancher/k3s:latest}"
REGISTRY_IMAGE="${FLOCI_REGISTRY_IMAGE:-registry:2}"
K3S_PORT="${FLOCI_K3S_PORT:-6504}"
REGISTRY_PORT="${FLOCI_REGISTRY_PORT:-5100}"
TOKEN_WEBHOOK_FILE="${FLOCI_TOKEN_WEBHOOK_FILE:-${SCRIPT_DIR}/token-webhook.yaml}"
REGISTRIES_FILE="${FLOCI_REGISTRIES_FILE:-${SCRIPT_DIR}/registries.yaml}"

# ── Create a user-defined Docker network ──────────────────────────────────
# Required: Docker embedded DNS resolves container names on this network,
# so containerd mirror endpoints like "floci-ecr-registry:5000" work.
echo "ℹ️  Creating Docker network '${NETWORK_NAME}'..."
docker network create "${NETWORK_NAME}" 2>/dev/null || \
  echo "   Network already exists, reusing."

# ── Local container registry ──────────────────────────────────────────────
echo "ℹ️  Creating registry '${REGISTRY_NAME}'..."
docker rm -f "${REGISTRY_NAME}" 2>/dev/null || true
docker run -d \
  --name "${REGISTRY_NAME}" \
  --network "${NETWORK_NAME}" \
  -p "${REGISTRY_PORT}:5000" \
  -e REGISTRY_STORAGE_DELETE_ENABLED=true \
  -e REGISTRY_HTTP_ADDR=:5000 \
  -v "${REGISTRY_NAME}-data:/var/lib/registry" \
  "${REGISTRY_IMAGE}"

# ── Write the token-webhook config ────────────────────────────────────────
# This tells the kube-apiserver to validate bearer tokens against the
# localstack EKS token webhook (floci emulation).
mkdir -p "$(dirname "${TOKEN_WEBHOOK_FILE}")"
cat > "${TOKEN_WEBHOOK_FILE}" <<'EOF'
apiVersion: v1
kind: Config
clusters:
- name: floci-token-webhook
  cluster:
    server: http://host.docker.internal:4566/_floci/eks/token-webhook
users:
- name: floci-token-webhook
contexts:
- name: floci-token-webhook
  context:
    cluster: floci-token-webhook
    user: floci-token-webhook
current-context: floci-token-webhook
EOF

# ── K3s server node ───────────────────────────────────────────────────────
echo "ℹ️  Creating k3s node '${CLUSTER_NAME}'..."

# Mount registries.yaml (read-only) so containerd trusts the local registry
# Mount token-webhook.yaml so EKS token auth works
docker rm -f "${CLUSTER_NAME}" 2>/dev/null || true
docker run -d \
  --name "${CLUSTER_NAME}" \
  --privileged \
  --network "${NETWORK_NAME}" \
  -p "${K3S_PORT}:6443" \
  -e K3S_KUBECONFIG_MODE=644 \
  -v "${REGISTRIES_FILE}:/etc/rancher/k3s/registries.yaml:ro" \
  -v "${TOKEN_WEBHOOK_FILE}:/etc/token-webhook.yaml:ro" \
  -v "${CLUSTER_NAME}-data:/var/lib/rancher/k3s" \
  "${K3S_IMAGE}" \
  server \
    --disable=traefik \
    --tls-san=localhost \
    --kube-apiserver-arg=authentication-token-webhook-config-file=/etc/token-webhook.yaml \
    --kube-apiserver-arg=authentication-token-webhook-version=v1 \
    --kube-apiserver-arg=authentication-token-webhook-cache-ttl=30s

# ── Wait for node Ready ──────────────────────────────────────────────────
echo "⏳ Waiting for node to be Ready..."
K3S_KUBECONFIG=$(mktemp)
trap 'rm -f "${K3S_KUBECONFIG}"' EXIT
docker cp "${CLUSTER_NAME}:/etc/rancher/k3s/k3s.yaml" "${K3S_KUBECONFIG}" 2>/dev/null
sed -i '' "s/127.0.0.1/localhost/g; s/6443/${K3S_PORT}/g" "${K3S_KUBECONFIG}"
export KUBECONFIG="${K3S_KUBECONFIG}"

for i in $(seq 1 30); do
  if kubectl get nodes -o wide 2>/dev/null | grep -q "Ready"; then
    echo "✅ Node is Ready!"
    break
  fi
  echo "   ... waiting ($i/30)"
  sleep 3
done

echo "✅ Cluster created."
echo
echo "Export the kubeconfig:"
echo "  export KUBECONFIG=${K3S_KUBECONFIG}"
echo
echo "Or use the persistent config:"
echo "  docker cp ${CLUSTER_NAME}:/etc/rancher/k3s/k3s.yaml ~/.kube/floci-config"
echo "  sed -i '' 's/127.0.0.1/localhost/g; s/6443/${K3S_PORT}/g' ~/.kube/floci-config"
echo "  export KUBECONFIG=~/.kube/floci-config"