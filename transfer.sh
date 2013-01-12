#!/bin/bash
set -u
set -e

SCRIPT_DIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
SCANS_DIR="$1"
SCAN_DIRNAME="$( basename "$SCANS_DIR" )"
NAS_DIR="/mnt/nas/scans"
STAGING_DIR="$NAS_DIR/staging"
READY_DIR="$NAS_DIR/ready"

if [ ! -d "$NAS_DIR" ]; then
  echo "No target"
fi

if [ ! -d "$NAS_DIR" ]; then
  echo "No network!"
  exit 1
fi

if [ ! -d "$STAGING_DIR" ]; then
  mkdir "$STAGING_DIR"
fi

if [ ! -d "$READY_DIR" ]; then
  mkdir "$READY_DIR"
fi

mv "$SCANS_DIR" "$STAGING_DIR"
mv "$STAGING_DIR/$SCAN_DIRNAME" "$READY_DIR"

