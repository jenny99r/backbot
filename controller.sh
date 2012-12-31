#!/bin/bash
set -u
set -e

SCRIPT_DIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

gpio-admin export 22

while : do
  while [ `cat /sys/devices/virtual/gpio/gpio22/value` = 1 ]; do
    sleep 0.05
  done
  "$SCRIPT_DIR"/scan.sh
done
