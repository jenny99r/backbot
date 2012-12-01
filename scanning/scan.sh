#!/bin/bash
set -u
set -e

WRKDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

/bin/echo "Scanning Started: $(date)"

scanimage --mode "Color" --device-name "fujitsu:ScanSnap S1500:94374" -y 297 -x 210 --page-width 210 --page-height 297 --batch --source "ADF Duplex" --resolution 180 --format=tiff

tiffcp "out*.tif" "combined.tif"

convert "combined.tif" -compress "JPEG" -quality 60 "final.pdf"

tesseract "combined.tif" "final"

