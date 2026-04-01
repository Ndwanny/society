#!/bin/bash
set -e

FLUTTER_VERSION="3.22.0"

# Install Flutter into home directory
curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
  | tar xJ -C "$HOME"

# Overwrite Cloudflare's pre-installed Flutter with ours so it cannot be bypassed
if [ -d "/opt/buildhome/flutter" ]; then
  rm -rf /opt/buildhome/flutter 2>/dev/null || true
  ln -sf "$HOME/flutter" /opt/buildhome/flutter 2>/dev/null || true
fi

FLUTTER="$HOME/flutter/bin/flutter"

"$FLUTTER" config --no-analytics
"$FLUTTER" pub get

"$FLUTTER" build web --release \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"
