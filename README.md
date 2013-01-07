Raspberry Pi Scanstation
========================

Setup
-----

Start with a clean Rasbian installation (with updates)

```bash
wget https://github.com/scarytom/backbot/archive/rpi-scanstation.zip
unzip rpi-scanstation.zip
rm rpi-scanstation.zip
backbot-rpi-scanstation/install.sh
```
log out, then in again.


Notes of by-hand setup
----------------------

```bash
sudo apt-get install sane-utils libtiff-tools
sudo adduser $USER scanner
wget https://github.com/scarytom/backbot/archive/rpi-scanstation.zip
unzip rpi-scanstation.zip
backbot-rpi-scanstation/setup.sh
```

```bash
wget https://github.com/quick2wire/quick2wire-gpio-admin/archive/master.zip
unzip master.zip
cd quick2wire-gpio-admin-master/
make
sudo make install
sudo adduser $USER gpio
```

log out, then in again.

