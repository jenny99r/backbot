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
apt-get install cifs-utils autofs
echo '/mnt/nas /etc/auto.nas --timeout 120' >> /etc/auto.master
echo 'scans -fstype=cifs,username=scan,password=scan,rw ://phlox/scans' > /etc/auto.nas
chmod 644 /etc/auto.scans
service autofs restart

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
apt-get install sane-utils libtiff-tools
adduser $USER scanner
