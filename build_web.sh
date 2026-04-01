#!/bin/bash
# Manual build + deploy to Cloudflare Pages
# Usage: SUPABASE_URL=https://xyz.supabase.co SUPABASE_ANON_KEY=... ./build_web.sh

set -e

echo "Building Flutter web..."
flutter build web --release \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"

echo "Deploying to Cloudflare Pages..."
npx wrangler pages deploy build/web \
  --project-name=society260 \
  --commit-dirty=true

echo "Done! Visit https://society260.pages.dev"
