#!/bin/bash
set -u
set -e

SCRIPTDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
SCANBUTTONDDIR="/etc/scanbuttond"

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit 1
fi

if [ ! -d "$SCANBUTTONDDIR" ]; then
    echo "scanbuttond not installed"
    exit 1
fi

cp "$SCRIPTDIR"/initscanner.sh "$SCANBUTTONDDIR"/.
cp "$SCRIPTDIR"/buttonpressed.sh "$SCANBUTTONDDIR"/.
cp "$SCRIPTDIR"/scanbuttond.defaults /etc/default/scanbuttond
echo "SCRIPTDIR=\"$SCRIPTDIR\"" > "$SCANBUTTONDDIR"/env.conf

touch /var/log/scanbuttond.log
chmod 666 /var/log/scanbuttond.log

service scanbuttond restart


