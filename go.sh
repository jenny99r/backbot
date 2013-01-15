#!/bin/bash
set -u
set -e

STARTDIR="$( /bin/pwd )"
SCRIPTDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
TMPDIR=`mktemp -d`
SAMBADIR="$TMPDIR"/samba
READYDIR="$SAMBADIR"/phlox.lan/scans/ready
DONEDIR="$SAMBADIR"/phlox.lan/scans/done

# mount samba shares
/bin/rm -fr "$HOME"/.smb
/bin/cp -R "$SCRIPTDIR"/smb-conf "$HOME"/.smb
/bin/echo "auth phlox.lan scan scan" > "$HOME"/.smb/smbnetfs.auth
/bin/chmod 600 "$HOME"/.smb/*

/bin/mkdir -p $SAMBADIR
/usr/bin/smbnetfs $SAMBADIR

find "$READYDIR" -mindepth 1 -maxdepth 1 -type d \
     -exec "$SCRIPTDIR/process.sh" '{}' $DONEDIR \;

sleep 15
/bin/fusermount -u $SAMBADIR
/bin/rm -fr $SAMBADIR

#convert "combined.tif" -compress "JPEG" -quality 60 "final.pdf"
#tesseract "combined.tif" "final"
#cp "final.pdf" "$STARTDIR"/.
#cp "final.txt" "$STARTDIR"/.

