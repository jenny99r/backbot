#!/bin/bash
set -u
set -e

WRKDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
TMPDIR=`mktemp -d`
OUTFILE="$HOME"/scan-$(date -u +%Y%m%d%H%M%S).tif

echo "Scanning Started: $(date)"

cd "$TMPDIR"
scanimage --mode "Color" --device-name "fujitsu:ScanSnap S1500:94374" -y 297 -x 210 --page-width 210 --page-height 297 --batch --source "ADF Duplex" --resolution 180 --format=tiff && echo ""

tiffcp "$TMPDIR"/out*.tif "$OUTFILE"
rm -fr "$TMPDIR"

echo "Scanning Finished: $(date)"
