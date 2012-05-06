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

ls "$HOME"/samba/phlox.lan/tom

# unmount samba shares
/bin/fusermount -u "$HOME"/samba
/bin/rm -fr "$HOME"/samba

/usr/local/bin/u1sync --oauth="$U1OAUTH" --action=upload "$U1DIR"

/bin/echo "Nightly Backup Successful: $(date)" >> "$LOGFILE"
