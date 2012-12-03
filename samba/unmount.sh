#!/bin/bash
set -u
set -e

SAMBADIR="$HOME"/samba

# unmount samba shares
/bin/fusermount -u $SAMBADIR
/bin/rm -fr $SAMBADIR

