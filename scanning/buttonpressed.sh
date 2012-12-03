#!/bin/bash
set -u
set -e

LOG="/var/log/scanbuttond.log"

# This script is started by scanbuttond whenever a scanner button has been pressed.
# Scanbuttond passes the following parameters to us:
# $1 ... the button number
# $2 ... the scanner's SANE device name, which comes in handy if there are two or 
#        more scanners. In this case we can pass the device name to SANE programs 
#        like scanimage.
LOCKFILE="/tmp/scanbuttond"
if ! lockfile-create --retry 2 $LOCKFILE; then
  echo "Error: scanning already in progress for $2" >> $LOG
  exit 1
fi

MYDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
source "$MYDIR"/env.conf

SCANSCRIPT="$SCRIPTDIR"/scan.sh
if [ ! -f "$SCANSCRIPT" ]; then
    echo "scanscript $SCANSCRIPT not found" >> $LOG
    lockfile-remove $LOCKFILE
    exit 1
fi

echo "executing $SCANSCRIPT" >> $LOG
set +e
$SCANSCRIPT 1>>$LOG 2>&1
set -e
echo "done with $SCANSCRIPT" >> $LOG

lockfile-remove $LOCKFILE

