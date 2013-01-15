#!/bin/bash
set -u
set -e

SCRIPTDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

cd "$SCRIPTTDIR"
ORIGIN=`git config --get remote.origin.url`

cd $HOME
if [ ! -f jenkins.war ];
then
  echo "Downloading Jenkins..."
  wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war
fi

if [ ! -f .jenkins ];
then
  echo "Restoring Jenkins configuration"
  git clone $ORIGIN -b jenkins-backup jenkins
fi

java -jar jenkins.war -DJENKINS_HOME=$HOME/jenkins &

