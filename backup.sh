#!/bin/sh
set -u
set -e

U1DIR=$HOME/u1
U1OATH=`cat $HOME/u1oath.key`
LOGFILE=$HOME/backup.log


echo "Nightly Backup Started: $(date)" >> $LOGFILE

/usr/local/bin/u1sync --oauth=$U1AUTH --action=upload $U1DIR

echo "Nightly Backup Successful: $(date)" >> $LOGFILE
