#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST_DIR="$REPO_ROOT/dist"
OUTPUT_BIN="$DIST_DIR/gnomad"

echo "Building standalone gnomad bundle..."

mkdir -p "$DIST_DIR"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

# Stage files into temporary packaging directory
mkdir -p "$TEMP_DIR/bundle"
cp "$REPO_ROOT/gnomad" "$TEMP_DIR/bundle/"
cp -r "$REPO_ROOT/cli" "$TEMP_DIR/bundle/"
cp -r "$REPO_ROOT/utils" "$TEMP_DIR/bundle/"
cp -r "$REPO_ROOT/profiles" "$TEMP_DIR/bundle/"

# Ensure executable bits
chmod +x "$TEMP_DIR/bundle/gnomad"
chmod +x "$TEMP_DIR/bundle/cli"/*.sh
chmod +x "$TEMP_DIR/bundle/utils"/*.sh 2>/dev/null || true
chmod +x "$TEMP_DIR/bundle/utils/export"/*.sh 2>/dev/null || true
chmod +x "$TEMP_DIR/bundle/utils/import"/*.sh 2>/dev/null || true

# Create tar.gz payload
TAR_FILE="$TEMP_DIR/payload.tar.gz"
tar -czf "$TAR_FILE" -C "$TEMP_DIR/bundle" .

# Compute payload checksum
if command -v sha256sum >/dev/null 2>&1; then
  BUNDLE_SUM=$(sha256sum "$TAR_FILE" | cut -d' ' -f1 | head -c 16)
else
  BUNDLE_SUM=$(md5sum "$TAR_FILE" | cut -d' ' -f1 | head -c 16)
fi

# Write extractor header
cat << 'HEADER_EOF' > "$OUTPUT_BIN"
#!/bin/bash
set -e

GNOMAD_VERSION="0.2.0"
CACHE_BASE="${XDG_CACHE_HOME:-$HOME/.cache}/gnomad"
BUNDLE_SUM="__BUNDLE_SUM__"
RUNTIME_DIR="$CACHE_BASE/runtime-$BUNDLE_SUM"

if [ ! -d "$RUNTIME_DIR" ] || [ ! -f "$RUNTIME_DIR/.extracted" ]; then
  mkdir -p "$RUNTIME_DIR"
  ARCHIVE_LINE=$(awk '/^__PAYLOAD_BELOW__/ {print NR + 1; exit 0; }' "$0")
  tail -n +"$ARCHIVE_LINE" "$0" | base64 -d | tar -xz -C "$RUNTIME_DIR"
  touch "$RUNTIME_DIR/.extracted"
fi

export GNOMAD_LIB_DIR="$RUNTIME_DIR"
export GNOMAD_DATA_DIR="$RUNTIME_DIR"

exec "$RUNTIME_DIR/gnomad" "$@"

__PAYLOAD_BELOW__
HEADER_EOF

# Substitute checksum
sed -i "s/__BUNDLE_SUM__/$BUNDLE_SUM/g" "$OUTPUT_BIN"

# Append base64 encoded archive
base64 "$TAR_FILE" >> "$OUTPUT_BIN"
chmod +x "$OUTPUT_BIN"

echo "✓ Standalone binary created at: $OUTPUT_BIN"
echo "  File size: $(du -h "$OUTPUT_BIN" | cut -f1)"
