#!/bin/sh
set -u
set -e

U1DIR=$HOME/u1
U1OAUTH=`cat $HOME/u1oauth.key`
LOGFILE=$HOME/backup.log


echo "Nightly Backup Started: $(date)" >> $LOGFILE

/usr/local/bin/u1sync --oauth=$U1OAUTH --action=upload $U1DIR

echo "Nightly Backup Successful: $(date)" >> $LOGFILE
