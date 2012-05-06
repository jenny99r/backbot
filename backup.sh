#!/bin/bash
set -u
set -e

WRKDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
U1DIR="$HOME"/u1
U1OAUTH=`/bin/cat "$HOME"/u1oauth.key`
LOGFILE="$HOME"/mybackup.log

/bin/echo "Nightly Backup Started: $(date)" >> $LOGFILE

/bin/cp -R "$WRKDIR"/smb "$HOME"/.smb 
/usr/local/bin/u1sync --oauth="$U1OAUTH" --action=upload "$U1DIR"

/bin/echo "Nightly Backup Successful: $(date)" >> "$LOGFILE"
