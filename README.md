backbot
=======

backup scripts and bits

__u1sync setup__
From a clean install of precise, these are the packages you need:
  * python-gobject
  * python-ubuntuone-storageprotocol
  * python-ubuntuone-client
  * python-ubuntu-sso-client

To obtain and setup u1sync, you'll also need bzr:
```bash
sudo apt-get install bzr
bzr branch lp:u1sync
sudo python u1sync/setup.py install
```

Then you'll need an oauth token...
```bash
wget --user=me@mine.com -O token-details --ask-password "https://login.ubuntu.com/api/1.0/authentications?ws.op=authenticate&token_name=Ubuntu%20One%20@%20$(hostname)"
wget -O token-approval "https://one.ubuntu.com/oauth/sso-finished-so-get-tokens/me%40mine.com"
```

or use this script: http://people.canonical.com/~roman.yepishev/us/ubuntuone-sso-login.py

references:
 * https://bugs.launchpad.net/u1sync/+bug/910207
 * http://per.liedman.net/2011/01/22/using-ubuntu-one-for-backup-on-a-headless-server/
 * http://per.liedman.net/2011/12/28/using-ubuntu-one-from-a-headless-oneiric-ocelot/

__u1sync usage__
```bash
mkdir u1/
u1sync --oauth=`cat u1oauth.key` --init u1/
u1sync --oauth=`cat u1oauth.key` --diff u1/
u1sync --oauth=`cat u1oauth.key` --dry-run --action=upload u1
```
__crontab__
```bash
crontab -e
01 04 * * * /home/tom/backbot/backup.sh
```

__mounting windows share__
```bash
sudo apt-get install smbfs
sudo update-rc.d -f umountnfs.sh remove
sudo update-rc.d umountnfs.sh stop 15 0 6 .
sudo apt-get install smbnetfs

cp /etc/samba/smb.conf ~/.smb/.
cp /etc/smbnetfs.conf ~/.smb/.
echo "auth host/share username password" > ~/.smb/smbnetfs.auth
chmod 600 ~/.smb/*

mkdir ~/samba-shares
smbnetfs ~/samba-shares
ls ~/samba-shares/host/share
fusermount -u ~/samba-shares
```
references:
 * https://help.ubuntu.com/community/MountWindowsSharesPermanently
 * http://manpages.ubuntu.com/manpages/hardy/man1/smbnetfs.1.html
