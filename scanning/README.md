backbot document scanning
=========================
_scanning scripts and bits_

Designed to be run on ubuntu, in a dedicated user account.

__prerequisites__
```bash
sudo apt-get install tesseract-ocr sane-utils imagemagick libtiff-tools
wget http://ftp.uk.debian.org/debian/pool/main/s/scanbuttond/scanbuttond_0.2.3.cvs20090713-11_amd64.deb
```

__setup__
```bash
git clone https://github.com/scarytom/backbot.git ~/backbot
~/backbot/scanning/setup.sh
```

How it works
============

__Stage 1 - Scanning__
* scanbuttond responds to button press on scanner triggering scan
* uses `scanimage` to scan all docs in duplex to tif files
* uses `tiffcp` to combine the tifs into a single file
* uploads the combined tif to a network drive

__Stage 2 - Processing__
* Jenkins job reads scans directory on network drive
* Detects new tiff files
* uses `convert` to turn tif into pdf with 60% JPEG compression
* uses `tesseract` to OCR the tif to a txt file
* removes tif

__Stage 3 - Backup__
* Encryption?

References
==========

 * http://www.robinclarke.net/archives/the-paperless-office-with-linux
 * http://jduck.net/2008/01/05/ocr-scanning/
 * http://en.gentoo-wiki.com/wiki/Scanner_buttons_and_one-touch_scanning
 * http://packages.debian.org/experimental/amd64/scanbuttond/download
