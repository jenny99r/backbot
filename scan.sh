#!/bin/bash
set -u
set -e

SCRIPT_DIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
OUTFILE="$HOME"/scan-$(date -u +%Y%m%d%H%M%S).tif
TMPDIR=`mktemp -d`

echo "Scanning Started: $(date)"

cd "$TMPDIR"
scanimage --mode "Color" --device-name "fujitsu:ScanSnap S1500:94374" -y 296.994 -x 210.01 --page-width 210.01 --page-height 297.994 --batch --source "ADF Duplex" --resolution 180 --format=tiff --sleeptimer 1 && echo ""

if [ ! -f "$TMPDIR/out*.tif" ]; then
  echo "nothing was scanned"
else
  tiffcp "$TMPDIR"/out*.tif "$OUTFILE"
fi

rm -fr "$TMPDIR"

echo "Scanning Finished: $(date)"
