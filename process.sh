#!/bin/bash
set -u
set -e

RUN_OCR=true
while getopts 'p' OPTION
do
  case $OPTION in
    p) RUN_OCR=false
  esac
done

shift $(($OPTIND - 1))

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
  if $RUN_OCR ; then
    tesseract "$FILE" "${FILE%%.*}"
  fi
  rm "$FILE"
  mv * "$DONEDIR"/.
  rm "$F"
done
shopt -u nullglob

rmdir "$SCANSDIR"
