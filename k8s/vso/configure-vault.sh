#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Logging into Vault ==="
vault login root

echo "=== Enabling Kubernetes Authentication ==="
# Enable kubernetes auth if not already enabled
vault auth enable kubernetes || true

echo "=== Configuring Kubernetes Auth ==="
# Configure Vault to communicate with the Kubernetes API
vault write auth/kubernetes/config \
    kubernetes_host="https://kubernetes.default.svc"

echo "=== Creating Policy 'app-policy' ==="
# Write policy to allow read access to the DB credentials secret path
cat <<EOF > /tmp/app-policy.hcl
path "secret/data/dev/db-credentials" {
  capabilities = ["read"]
}
EOF

vault policy write app-policy /tmp/app-policy.hcl

echo "=== Creating Role 'app-role' ==="
# Map the Kubernetes 'default' service account in 'default' namespace to 'app-role' with 'app-policy'
vault write auth/kubernetes/role/app-role \
    bound_service_account_names=default \
    bound_service_account_namespaces=default \
    policies=app-policy \
    audience="vault" \
    ttl=24h

echo "=== Vault Configuration Complete! ==="
