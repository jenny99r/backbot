#!/bin/bash
set -u
set -e

SCRIPTDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
SAMBADIR="$HOME"/samba

# mount samba shares
/bin/rm -fr "$HOME"/.smb
/bin/cp -R "$SCRIPTDIR"/smb-conf "$HOME"/.smb 
/bin/cp "$HOME"/smbnetfs.auth "$HOME"/.smb
/bin/chmod 600 "$HOME"/.smb/*

/bin/mkdir -p $SAMBADIR
/usr/bin/smbnetfs $SAMBADIR

