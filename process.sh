#!/bin/bash
set -u
set -e

STARTDIR="$( /bin/pwd )"
SCRIPTDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
TMPDIR=`mktemp -d`
SCANSDIR="$1"
DONEDIR="$2"

echo "Processing $SCANSDIR"

#convert "combined.tif" -compress "JPEG" -quality 60 "final.pdf"
#tesseract "combined.tif" "final"
#cp "final.pdf" "$STARTDIR"/.
#cp "final.txt" "$STARTDIR"/.

