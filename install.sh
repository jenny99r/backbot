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
apt-get install smbfs
update-rc.d -f umountnfs.sh remove
update-rc.d umountnfs.sh stop 15 0 6 .
apt-get install smbnetfs
cp /etc/samba/smb.conf ~/.smb/.
cp /etc/smbnetfs.conf ~/.smb/.
echo "auth host/share username password" > ~/.smb/smbnetfs.auth
chmod 600 ~/.smb/*

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
