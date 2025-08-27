#!/usr/bin/env bash
# VPSmith installer – Created by Digital Platform Online Studios
set -e

echo "=== VPSmith installer ==="
echo -n "Domain to use (or IP): "
read DOMAIN

echo "You entered: $DOMAIN"
echo "Installing Docker (if missing)..."
apt-get update -qq
apt-get install -y docker.io docker-compose-plugin

echo "Pulling VPSmith stack..."
mkdir -p /opt/vpsmith
cd /opt/vpsmith
curl -fsSL https://raw.githubusercontent.com/Rosscore100/vpsmith/main/docker-compose.yml -o docker-compose.yml || true

echo "Starting services..."
docker compose up -d

echo "VPSmith should now be reachable at https://$DOMAIN"
