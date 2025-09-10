#!/usr/bin/env bash
set -euo pipefail

# === Settings (env で上書き可) ===
PORT="${PORT:-4000}"
LR_PORT="${LR_PORT:-35729}"
HOST="${HOST:-127.0.0.1}"
BASEURL="${BASEURL:-}"             # ローカルは空でOK
THEME_GEM_NAME="${THEME_GEM_NAME:-jekyll-theme-nino8}"  # gem名（必要に応じて変更）

# === Paths ===
ROOT="$(cd "$(dirname "$0")" && pwd)"
EXAMPLE_DIR="$ROOT/example"

echo "=> Theme root: $ROOT"
echo "=> Example dir: $EXAMPLE_DIR"

# === Prepare example site (create if missing) ===
mkdir -p "$EXAMPLE_DIR"

if [ ! -f "$EXAMPLE_DIR/Gemfile" ]; then
  cat > "$EXAMPLE_DIR/Gemfile" <<'RUBY'
source "https://rubygems.org"
gem "jekyll", "~> 4.4"
# ローカルのテーマを参照（このGemfileから見て一つ上のディレクトリ）
gem "jekyll-theme-nino8", path: ".."
RUBY
fi

if [ ! -f "$EXAMPLE_DIR/_config.yml" ]; then
  cat > "$EXAMPLE_DIR/_config.yml" <<YML
title: Theme Sandbox
theme: ${THEME_GEM_NAME}
baseurl: ""
YML
fi

if [ ! -f "$EXAMPLE_DIR/index.md" ]; then
  cat > "$EXAMPLE_DIR/index.md" <<'MD'
---
layout: page
title: Hello Theme
---
This is a sandbox for the theme. Edit files in the theme repo and reload.
MD
fi

# === Free ports if needed ===
if command -v fuser >/dev/null 2>&1; then
  fuser -k "${PORT}"/tcp 2>/dev/null || true
  fuser -k "${LR_PORT}"/tcp 2>/dev/null || true
fi

# === Install & Serve ===
cd "$EXAMPLE_DIR"
echo "=> bundle install ..."
bundle install --quiet

echo "=> jekyll clean ..."
bundle exec jekyll clean

echo "=> jekyll serve on http://$HOST:$PORT/ (livereload:$LR_PORT)"
bundle exec jekyll serve \
  --host "$HOST" \
  --port "$PORT" \
  --livereload \
  --livereload-port "$LR_PORT" \
  --baseurl "$BASEURL"