#!/bin/bash
set -u
set -e

WRKDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
U1DIR="$HOME"/u1
U1OAUTH=`/bin/cat "$HOME"/u1oauth.key`
LOGFILE="$HOME"/mybackup.log

/bin/echo "Nightly Backup Started: $(date)" >> $LOGFILE

# mount samba shares
/bin/rm -fr "$HOME"/.smb
/bin/cp -R "$WRKDIR"/smb "$HOME"/.smb 
/bin/cp "$HOME"/smbnetfs.auth "$HOME"/.smb
/bin/chmod 600 "$HOME"/.smb/*

/bin/mkdir -p "$HOME"/samba
/usr/bin/smbnetfs "$HOME"/samba

/bin/mkdir -p "$HOME"/local/mainbackup
/usr/bin/rsync -za --delete "$HOME"/samba/phlox.lan/tom/ "$HOME"/local/mainbackup/

# unmount samba shares
/bin/fusermount -u "$HOME"/samba
/bin/rm -fr "$HOME"/samba

#sync the remote backup directory and push it
if /usr/bin/rsync -zav --delete --exclude=.ubuntuone-sync --dry-run "$HOME"/local/ "$U1DIR"/ | /bin/grep -q '^deleting .*backup.keyfile$'; then
 /bin/echo "Fatal Error -- deleting keyfile"
 exit 1
fi
/usr/bin/rsync -zav --delete --exclude=.ubuntuone-sync "$HOME"/local/ "$U1DIR"/
/usr/local/bin/u1sync --oauth="$U1OAUTH" --action=clobber-server "$U1DIR"

/bin/echo "Nightly Backup Successful: $(date)" >> "$LOGFILE"
