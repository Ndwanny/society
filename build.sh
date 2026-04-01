#!/bin/bash
set -e

# Install Flutter into home directory (writable in Cloudflare Pages)
FLUTTER_VERSION="3.22.0"
curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
  | tar xJ -C "$HOME"

export PATH="$HOME/flutter/bin:$PATH"

flutter config --no-analytics
flutter pub get

flutter build web --release \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"
