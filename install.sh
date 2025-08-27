#!/usr/bin/env bash
# VPSmith installer – Created by Digital Platform Online Studios
# Published by Digital Platform Online
set -e

echo "=== VPSmith installer ==="
echo -n "Domain to use (or IP): "
read DOMAIN
echo "You entered: $DOMAIN"

# ── 1. Ensure Docker & compose are already present --------------------------
if ! command -v docker >/dev/null 2>&1; then
    echo "❌  Docker not found. Install it manually, then re-run this script."
    exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
    echo "❌  Docker Compose plugin not found. Install it manually, then re-run."
    exit 1
fi
echo "✅  Docker already installed."

# ── 2. Pull / create project directory --------------------------------------
INSTALL_DIR="/opt/vpsmith"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# ── 3. Download docker-compose.yml (create a minimal one if missing) --------
COMPOSE_FILE="$INSTALL_DIR/docker-compose.yml"
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "Creating minimal docker-compose.yml ..."
    cat > "$COMPOSE_FILE" <<'EOF'
services:
  app:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    restart: unless-stopped
EOF
else
    echo "Using existing docker-compose.yml"
fi

# ── 4. Start the stack ------------------------------------------------------
echo "Starting services..."
docker compose pull
docker compose up -d --remove-orphans

# ── 5. Done -----------------------------------------------------------------
echo "------------------------------------------------------"
echo "VPSmith is live at https://$DOMAIN"
echo "------------------------------------------------------"
