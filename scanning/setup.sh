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

#ensure the saned user is in the scanner group (can access scanner)
usermod -G scanner -a saned

cp "$SCRIPTDIR"/initscanner.sh "$SCANBUTTONDDIR"/.
cp "$SCRIPTDIR"/buttonpressed.sh "$SCANBUTTONDDIR"/.

echo "
RUN=yes
RUN_AS_USER=$SUDO_USER
QUIET_LOG=1" > /etc/default/scanbuttond

echo "SCRIPTDIR=\"$SCRIPTDIR\"" > "$SCANBUTTONDDIR"/env.conf

touch /var/log/scanbuttond.log
chmod 666 /var/log/scanbuttond.log

service scanbuttond restart


