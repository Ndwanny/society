#!/bin/bash
set -e

# Install Flutter
FLUTTER_VERSION="3.22.0"
curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
  | tar xJ -C /opt

export PATH="/opt/flutter/bin:$PATH"

flutter config --no-analytics
flutter pub get

flutter build web --release --no-wasm-dry-run \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"
