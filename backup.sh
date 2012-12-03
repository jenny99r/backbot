#!/bin/bash
set -u
set -e

SCRIPTDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
U1DIR="$HOME"/u1
U1OAUTH=`/bin/cat "$HOME"/u1oauth.key`
LOGFILE="$HOME"/log/$(date -u +%Y%m%d%H%M%S).log
SAMBADIR="$HOME"/samba

/bin/echo "Nightly Backup Started: $(date)" >> "$LOGFILE"

$SCRIPTDIR/samba/mount.sh

/bin/mkdir -p "$HOME"/local/mainbackup
/usr/bin/rsync -za --delete "$HOME"/samba/phlox.lan/tom/ "$HOME"/local/mainbackup/
/usr/bin/rsync -zac --include='*/' --include='*.tc' --exclude='*' "$HOME"/samba/phlox.lan/tom/ "$HOME"/local/mainbackup/

$SCRIPTDIR/samba/unmount.sh

#sync the remote backup directory and push it
if /usr/bin/rsync -zav --delete --exclude=.ubuntuone-sync --dry-run "$HOME"/local/ "$U1DIR"/ | /bin/grep -q '^deleting .*backup.keyfile$'; then
 /bin/echo "Fatal Error -- deleting keyfile"
 exit 1
fi
/usr/bin/rsync -zav --delete --exclude=.ubuntuone-sync "$HOME"/local/ "$U1DIR"/ >> "$LOGFILE" 2>&1
/usr/bin/rsync -zacv --include='*/' --include='*.tc' --exclude='*' "$HOME"/local/ "$U1DIR"/ >> "$LOGFILE" 2>&1
/usr/local/bin/u1sync --oauth="$U1OAUTH" --action=clobber-server "$U1DIR" >> "$LOGFILE" 2>&1

/bin/echo "Nightly Backup Successful: $(date)" >> "$LOGFILE"
