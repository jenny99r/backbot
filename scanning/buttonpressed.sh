#!/bin/bash
set -u
set -e

# This script is started by scanbuttond whenever a scanner button has been pressed.
# Scanbuttond passes the following parameters to us:
# $1 ... the button number
# $2 ... the scanner's SANE device name, which comes in handy if there are two or 
#        more scanners. In this case we can pass the device name to SANE programs 
#        like scanimage.

LOCKFILE="/tmp/scanbuttond"
if ! lockfile-create --retry 2 $LOCKFILE; then
  echo "Error: scanning already in progress for $2"
  exit
fi

MYDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
source "$MYDIR"/env.conf

"$SCRIPTDIR"/scan.sh

lockfile-remove $LOCKFILE

