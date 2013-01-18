document scanning post-processing
=================================

__prerequisites__
```bash
sudo apt-get install tesseract-ocr imagemagick
```

How it works
============

* Jenkins job reads scans directory on network drive
* Detects new tiff files
* uses `convert` to turn tif into pdf with 60% JPEG compression
* uses `tesseract` to OCR the tif to a txt file
* removes tif

References
==========

 * http://www.robinclarke.net/archives/the-paperless-office-with-linux
 * http://jduck.net/2008/01/05/ocr-scanning/
 * http://en.gentoo-wiki.com/wiki/Scanner_buttons_and_one-touch_scanning
 * http://packages.debian.org/experimental/amd64/scanbuttond/download
