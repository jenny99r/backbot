#!/bin/bash
set -u
set -e

SCRIPT_DIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
OUT_DIR="$HOME/scans/$(date -u +%Y%m%d%H%M%S)"
OUT_FILE="$OUT_DIR"/scan-$(date -u +%Y%m%d%H%M%S).tif
TMP_DIR=`mktemp -d`
SINGLE=0
DUPLEX=0
SOURCE="ADF Duplex"

echo "Scanning Started: $(date)"

if [ $1 = "multiple" ];
then
  SINGLE=1
fi;

if [ $2 = "simplex" ];
then
  DUPLEX=1
  SOURCE="ADF Front"
fi;

cd "$TMP_DIR"
scanimage --mode "Color" --device-name "fujitsu:ScanSnap S1500:94374" -y 297 -x 210 --page-width 210 --page-height 297 --batch="out%03d.tif" --source "$SOURCE" --resolution 180 --format=tiff --sleeptimer 1 && echo ""

if [ ! -f "$TMP_DIR/out001.tif" ]; then
  echo "nothing was scanned"
  exit 0
fi

if [ ! -d "$OUT_DIR" ]; then
  mkdir -p "$OUT_DIR"
fi

if [ $SINGLE -eq 0 ]; then
  tiffcp "$TMP_DIR"/out*.tif "$OUT_FILE"
elif [ $DUPLEX -eq 0 ]; then
  for file in "$TMP_DIR"/out*.tif ; do
    NUM=${file##*out}; NUM=${NUM%.*}; NUM=`echo $NUM|sed 's/^0*//'`
    if (($NUM % 2)); then
      NUM2=$(expr $NUM + 1); printf -v NUM2 "%03d" $NUM2
      tiffcp "$TMP_DIR/out$NUM.tif" "$TMP_DIR/out$NUM2.tif" "${OUT_FILE%.*}-$NUM.${OUT_FILE##*.}"
    fi
  done
else
  for file in "$TMP_DIR"/out*.tif ; do
    mv "$file" "${OUT_FILE%.*}-${file##*out}"
  done
fi

rm -fr "$TMP_DIR"

"$SCRIPT_DIR"/transfer.sh "$OUT_DIR"

echo "Scanning Finished: $(date)"
