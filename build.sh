#!/bin/bash
set -e

FLUTTER_VERSION="3.22.0"
FLUTTER="$HOME/flutter/bin/flutter"

# Install Flutter ($HOME = /opt/buildhome on Cloudflare Pages)
curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
  | tar xJ -C "$HOME"

"$FLUTTER" config --no-analytics
"$FLUTTER" pub get

"$FLUTTER" build web --release \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"
