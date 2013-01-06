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

is_duplex() {
  if read $DUPLEX;
  then
    return "duplex"
  fi
  return "simplex"
}

scan() {
  "$SCRIPT_DIR"/scan.sh $1 is_duplex
}

while :
do
  while ! ( read $PORT_SCAN_SINGLE || read $PORT_SCAN_MULTIPLE || read $PORT_POWER ); do
    sleep 0.02
  done

  if read $PORT_POWER;
  then
    echo "powering down"
    exit 0;
  elif read $PORT_SCAN_SINGLE;
  then
    echo "scanning single"
  elif read $PORT_SCAN_MULTIPLE;
  then
    echo "scanning multiple"
  fi
done

