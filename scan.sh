#!/bin/bash
set -u
set -e

SCRIPT_DIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
OUTFILE="$HOME"/scan-$(date -u +%Y%m%d%H%M%S).tif
TMPDIR=`mktemp -d`
SINGLE=0
SOURCE="ADF Duplex"

echo "Scanning Started: $(date)"

if [ $1 = "multiple" ];
then
  SINGLE=1
fi;

if [ $2 = "simplex" ];
then
  SOURCE="ADF Front"
fi;

cd "$TMPDIR"
scanimage --mode "Color" --device-name "fujitsu:ScanSnap S1500:94374" -y 297 -x 210 --page-width 210 --page-height 297 --batch --source "$SOURCE" --resolution 180 --format=tiff --sleeptimer 1 && echo ""

if [ ! -f "$TMPDIR/out*.tif" ]; then
  echo "nothing was scanned"
elif $SINGLE
  tiffcp "$TMPDIR"/out*.tif "$OUTFILE"
else
  for file in "$TMPDIR"/out*.tif ; do
    mv "$file" "${OUTFILE%.*}-${file#out}"
  done
fi

rm -fr "$TMPDIR"

echo "Scanning Finished: $(date)"
