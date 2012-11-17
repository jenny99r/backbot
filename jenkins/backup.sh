#!/bin/bash
set -u
set -e

WRKDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

/bin/echo "Jenkins Backup Started: $(date)"

cd "$JENKINS_HOME"
if [ ! -f .git ];
then
  echo "Not Git"
fi

