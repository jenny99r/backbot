#!/bin/bash
set -u
set -e

SCRIPT_DIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
OUTFILE="$HOME"/scan-$(date -u +%Y%m%d%H%M%S).tif
TMPDIR=`mktemp -d`

echo "Scanning Started: $(date)"

cd "$TMPDIR"
scanimage --mode "Color" --device-name "fujitsu:ScanSnap S1500:94374" -y 297 -x 210 --page-width 210 --page-height 297 --batch --source "ADF Duplex" --resolution 180 --format=tiff --sleeptimer 1 && echo ""

tiffcp "$TMPDIR"/out*.tif "$OUTFILE"
rm -fr "$TMPDIR"

echo "Scanning Finished: $(date)"
