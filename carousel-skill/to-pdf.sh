#!/usr/bin/env bash
# to-pdf.sh - Convert a Nexcade carousel HTML file to a landscape 16:9 PDF.
#
# Usage:
#   ./to-pdf.sh input.html              # outputs input.pdf alongside the HTML
#   ./to-pdf.sh input.html output.pdf   # explicit output path
#
# Requirements:
#   - Google Chrome (macOS: /Applications/Google Chrome.app)
#
# The HTML must include the @media print CSS from base.html.
# That CSS sets @page size to 13.333in x 7.5in (16:9 landscape),
# forces grids to stay multi-column, and preserves background colours.

set -euo pipefail

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

if [[ ! -x "$CHROME" ]]; then
  echo "Error: Google Chrome not found at $CHROME" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: to-pdf.sh <input.html> [output.pdf]" >&2
  exit 1
fi

INPUT="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
OUTPUT="${2:-${INPUT%.html}.pdf}"

if [[ ! -f "$INPUT" ]]; then
  echo "Error: file not found: $INPUT" >&2
  exit 1
fi

# Chrome headless needs a throwaway profile dir (Chrome 145+)
PROFILE_DIR=$(mktemp -d /tmp/chrome-carousel-pdf.XXXXXX)
trap 'rm -rf "$PROFILE_DIR"' EXIT

# Chrome --print-to-pdf doesn't exit cleanly on macOS, so we background it
# and poll for the output file.
"$CHROME" \
  --headless=new \
  --disable-gpu \
  --no-sandbox \
  --disable-software-rasterizer \
  --disable-dev-shm-usage \
  --no-pdf-header-footer \
  --print-to-pdf="$OUTPUT" \
  --user-data-dir="$PROFILE_DIR" \
  "file://$INPUT" \
  >/dev/null 2>&1 &
PID=$!

# Wait up to 30s for the PDF to appear and stabilise
WAITED=0
PREV_SIZE=0
STABLE=0
while [[ $WAITED -lt 30 ]]; do
  # Check if Chrome exited early (crash / error)
  if ! kill -0 "$PID" 2>/dev/null && [[ ! -f "$OUTPUT" ]]; then
    echo "Error: Chrome exited without producing a PDF" >&2
    exit 1
  fi
  if [[ -f "$OUTPUT" ]]; then
    CUR_SIZE=$(wc -c < "$OUTPUT" | tr -d ' ')
    if [[ "$CUR_SIZE" -gt 0 && "$CUR_SIZE" -eq "$PREV_SIZE" ]]; then
      STABLE=$((STABLE + 1))
      # Two consecutive checks at the same size = write complete
      if [[ $STABLE -ge 2 ]]; then
        break
      fi
    else
      STABLE=0
    fi
    PREV_SIZE=$CUR_SIZE
  fi
  sleep 1
  WAITED=$((WAITED + 1))
done

kill "$PID" 2>/dev/null || true
wait "$PID" 2>/dev/null || true

if [[ -f "$OUTPUT" ]]; then
  SIZE=$(wc -c < "$OUTPUT" | tr -d ' ')
  if [[ "$SIZE" -eq 0 ]]; then
    echo "Error: PDF file is empty" >&2
    exit 1
  fi
  echo "$OUTPUT (${SIZE} bytes)"
else
  echo "Error: PDF generation failed (timed out after 30s)" >&2
  exit 1
fi
