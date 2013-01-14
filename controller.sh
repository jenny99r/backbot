#!/bin/bash
set -u
set -e

SCRIPT_DIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
GPIO_DIR="/sys/devices/virtual/gpio"
PORT_POWER=14
PORT_DUPLEX=4
PORT_SCAN_SINGLE=0
PORT_SCAN_MULTIPLE=1

register() {
  if [ ! -f "$GPIO_DIR/gpio$1/value" ]; then
    gpio-admin export "$1"
  fi
}

deregister() {
  if [ -f "$GPIO_DIR/gpio$1/value" ]; then
    gpio-admin unexport "$1"
  fi
}

gpio() {
  return `cat "$GPIO_DIR/gpio$1/value"`
}

scan() {
  MODE="duplex"
  if read $PORT_DUPLEX; then
    MODE="simplex"
  fi
  "$SCRIPT_DIR"/scan.sh $1 $MODE
}

teardown() {
  kill $LOOP_PID
  deregister $PORT_POWER
  deregister $PORT_DUPLEX
  deregister $PORT_SCAN_SINGLE
  deregister $PORT_SCAN_MULTIPLE
}

trap teardown SIGTERM SIGINT

register $PORT_POWER
register $PORT_DUPLEX
register $PORT_SCAN_SINGLE
register $PORT_SCAN_MULTIPLE

controlloop() {
  while :
  do
    while ! ( gpio $PORT_SCAN_SINGLE || gpio $PORT_SCAN_MULTIPLE || gpio $PORT_POWER );
    do
      sleep 0.02
    done

    if read $PORT_POWER; then
      echo "powering down..."
      sudo shutdown now
    elif read $PORT_SCAN_SINGLE; then
      echo "scanning single document..."
      scan "single"
    elif read $PORT_SCAN_MULTIPLE; then
      echo "scanning multiple documents..."
      scan "multiple"
    fi
  done
}

controlloop &
LOOP_PID=$!

wait $LOOP_PID
teardown
