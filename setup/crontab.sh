#!/bin/bash
set -u
set -e

BACKBOTDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && cd .. && /bin/pwd )"

echo "Setting up crontab"
crontab -r || echo ""
echo "01 03 * * * $BACKBOTDIR/backup.sh" | crontab -  
