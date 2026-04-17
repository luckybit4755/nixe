#!/usr/bin/env bash
# feather-image — feather alpha gradient around image edges
# Usage: feather-image <image> [feather_px] [blur_px]

set -euo pipefail

usage() {
  cat >&2 <<EOF
Usage: feather-image <image> [feather] [blur]

  image    Input image file (PNG recommended for alpha support)
  feather  Distance from edge where fade completes, in pixels (default: 40)
  blur     Extra blur sigma for softness — 0 for a hard linear fade (default: 5)

Examples:
  feather-image photo.png
  feather-image photo.png 60
  feather-image photo.png 60 10
EOF
  exit 1
}

die() { echo "error: $*" >&2; exit 1; }

[[ $# -lt 1 ]] && usage
[[ "$1" =~ ^(-h|--help)$ ]] && usage

INPUT="$1"
FEATHER="${2:-40}"
BLUR="${3:-5}"

[[ -f "$INPUT" ]] || die "file not found: $INPUT"
command -v convert >/dev/null 2>&1 || die "imagemagick not found — brew install imagemagick"

[[ "$FEATHER" =~ ^[0-9]+$ ]] || die "feather must be a positive integer, got: $FEATHER"
[[ "$BLUR"    =~ ^[0-9]+$ ]] || die "blur must be a positive integer, got: $BLUR"

DIR="$(dirname "$INPUT")"
BASE="$(basename "$INPUT")"
EXT="${BASE##*.}"

OUTPUT="${DIR}/feather-${BASE}"
if [[ "${EXT,,}" != "png" ]]; then
  echo "warning: '$EXT' may not support alpha — output saved as PNG"
  OUTPUT="${DIR}/feather-${BASE%.*}.png"
fi

W=$(identify -format "%w" "$INPUT")
H=$(identify -format "%h" "$INPUT")
MID_W=$((W - FEATHER * 2))
MID_H=$((H - FEATHER * 2))

[[ $MID_W -le 0 ]] && die "feather (${FEATHER}px) too large for image width (${W}px)"
[[ $MID_H -le 0 ]] && die "feather (${FEATHER}px) too large for image height (${H}px)"

echo "feathering: $INPUT -> $OUTPUT (feather=${FEATHER}px, blur=${BLUR}px, size=${W}x${H})"

# IM6 can't handle nested -append groups in the same convert call as the source image.
# So: build the alpha mask separately, then apply it.
#
# Vertical mask:   3 strips appended top-to-bottom (fade-in, white, fade-out)
# Horizontal mask: same rotated 90deg for left/right fades
# Multiply both:   corners get product of both fades — no diagonal over-erosion

MASK=$(mktemp /tmp/feather-mask-XXXXXX.png)
trap 'rm -f "$MASK"' EXIT

BLUR_ARG=""
[[ "$BLUR" -gt 0 ]] && BLUR_ARG="-blur 0x${BLUR}"

# Step 1: build the mask
convert \
  \( -size "${W}x${FEATHER}"  gradient:black-white \) \
  \( -size "${W}x${MID_H}"    xc:white \) \
  \( -size "${W}x${FEATHER}"  gradient:white-black \) \
  -append \
  \( \
    \( -size "${H}x${FEATHER}"  gradient:black-white \) \
    \( -size "${H}x${MID_W}"    xc:white \) \
    \( -size "${H}x${FEATHER}"  gradient:white-black \) \
    -append -rotate 90 \
  \) \
  -compose Multiply -composite \
  ${BLUR_ARG} \
  "$MASK"

# Step 2: apply mask as alpha to the source image
convert "$INPUT" "$MASK" -compose CopyOpacity -composite "$OUTPUT"

echo "done: $OUTPUT"
