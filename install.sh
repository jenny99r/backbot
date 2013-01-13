#!/bin/bash
set -u
set -e

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  echo "Not running as root"
  exit 1
fi

SCRIPT_DIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"
TMP_DIR=`mktemp -d`

cd "$TMP_DIR"

# setup windows shares
if [ ! -f /etc/auto.nas ]; then
  apt-get install cifs-utils autofs
  echo '/mnt/nas /etc/auto.nas --timeout 120' >> /etc/auto.master
  echo 'scans -fstype=cifs,username=scan,password=scan,rw ://phlox/scans' > /etc/auto.nas
  chmod 644 /etc/auto.nas
  service autofs restart
fi

# Quick2Wire gpio admin
if [ ! -f /usr/local/bin/gpio-admin ]; then
  echo "Installing GPIO admin"
  wget https://github.com/quick2wire/quick2wire-gpio-admin/archive/master.zip
  unzip master.zip
  cd quick2wire-gpio-admin-master/
  make
  make install
  adduser $USER gpio
fi

# setup scanner
if [ ! `cat /etc/group | grep pi | grep scanner` ]; then
  apt-get install sane-utils libtiff-tools
  adduser $USER scanner
fi

# setup statrup script
if [ ! -f /etc/init.d/scanstation ]; then
  mv "$SCRIPT_DIR"/scanstation /etc/init.d/.
  chown root:root /etc/init.d/scanstation
  update-rc.d scanstation defaults
fi

