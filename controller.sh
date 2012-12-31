#!/bin/bash

set -e

gpio-admin export 22

while [ `cat /sys/devices/virtual/gpio/gpio22/value` = 1 ]; do
  sleep 0.05
done


