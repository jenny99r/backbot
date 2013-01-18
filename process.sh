#!/bin/bash
set -u
set -e

TMPDIR=`mktemp -d`
SCANSDIR="$1"
DONEDIR="$2"

echo "Processing $SCANSDIR"

if [ ! -d "$DONEDIR" ]; then
  mkdir "$DONEDIR"
fi

cd "$TMPDIR"
shopt -s nullglob
for F in "$SCANSDIR"/*.tif
do
  FILE="${F##*/}"
  cp "$F" .
  convert "$FILE" -compress "JPEG" -quality 60 "${FILE%%.*}".pdf
  tesseract "$FILE" "${FILE%%.*}"
  rm "$FILE"
  mv * "$DONEDIR"/.
  rm "$F"
done
shopt -u nullglob

rmdir "$SCANSDIR"
