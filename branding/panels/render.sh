#!/bin/sh
# Render each panel in panels.html to out/<id>.png (320x100, transparent corner).
# Needs Chromium and ImageMagick: sudo pacman -S chromium imagemagick
# Usage: ./render.sh            (all panels)
#        ./render.sh about tips (only these)
set -e

cd "$(dirname "$0")"
CHROMIUM=${CHROMIUM:-chromium}
CHROMIUM_FLAGS=${CHROMIUM_FLAGS:-}
# headless Chromium shrinks the viewport below the window size, so render in a
# taller window and crop the panel out of the top.
if command -v magick >/dev/null; then IM=magick; else IM=convert; fi
PANELS=${*:-about schedule subscribe tips youtube discord}

mkdir -p out
for id in $PANELS; do
  "$CHROMIUM" $CHROMIUM_FLAGS --headless --disable-gpu --hide-scrollbars \
    --allow-file-access-from-files \
    --default-background-color=00000000 \
    --window-size=320,400 \
    --virtual-time-budget=2000 \
    --screenshot="$PWD/out/$id.png" \
    "file://$PWD/panels.html?panel=$id" 2>/dev/null
  $IM "out/$id.png" -crop 320x100+0+0 +repage "out/$id.png"
  echo "out/$id.png"
done
