#!/bin/bash
set -u
set -e

WRKDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

/bin/echo "Jenkins Backup Started: $(date)"

cd "$JENKINS_HOME"
if [ ! -d .git ];
then
  echo "Not git enabled"
  exit 1;
fi

SIZE="$( git ls-files -m -o --exclude-standard | while read f; do du -b "$f"; done | awk 'BEGIN {t=0} {t += $1} END {print t}' )"

if [ $SIZE -gt 9999 ];
then
  echo "A dubiously large amount of changes... human intervention recommended"
  exit 1;
fi

git add -A .
git status
git commit -m "Backup $(date)"
git push