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

SIZE="$( git ls-files -m -o --exclude-standard | while read f; do du "$f"; done | awk 'BEGIN {t=0} {t += $1} END {print t}' )"

echo $SIZE
