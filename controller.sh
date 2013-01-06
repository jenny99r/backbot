#!/bin/bash
set -u
set -e

SCRIPT_DIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

PORT_POWER=14
PORT_DUPLEX=4
PORT_SCAN_SINGLE=0
PORT_SCAN_MULTIPLE=1

gpio-admin export $PORT_POWER
gpio-admin export $PORT_DUPLEX
gpio-admin export $PORT_SCAN_SINGLE
gpio-admin export $PORT_SCAN_MULTIPLE

read() {
  return `cat /sys/devices/virtual/gpio/gpio$1/value`
}

scan() {
  MODE="duplex"
  if read $PORT_DUPLEX; then
    MODE="simplex"
  fi
  "$SCRIPT_DIR"/scan.sh $1 $MODE
}

while :
do
  while ! ( read $PORT_SCAN_SINGLE || read $PORT_SCAN_MULTIPLE || read $PORT_POWER ); do
    sleep 0.02
  done

  if read $PORT_POWER; then
    echo "powering down..."
    gpio-admin unexport $PORT_POWER
    gpio-admin unexport $PORT_DUPLEX
    gpio-admin unexport $PORT_SCAN_SINGLE
    gpio-admin unexport $PORT_SCAN_MULTIPLE
    sudo shutdown now
    exit 0;
  elif read $PORT_SCAN_SINGLE; then
    echo "scanning single document..."
    scan "single"
  elif read $PORT_SCAN_MULTIPLE; then
    echo "scanning multiple documents..."
    scan "multiple"
  fi
done

