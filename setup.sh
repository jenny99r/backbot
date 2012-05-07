#!/bin/bash
set -u
set -e

BACKBOTDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
$BACKBOTDIR/setup/crontab.sh
