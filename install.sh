#!/bin/bash
set -u
set -e

SCRIPTDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

cd "$SCRIPTDIR"
ORIGIN=`git config --get remote.origin.url`

cd $HOME
if [ ! -f jenkins.war ]; then
  echo "Downloading Jenkins..."
  wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war
fi

export JENKINS_HOME=$HOME/jenkins
if [ ! -d $JENKINS_HOME ]; then
  echo "Restoring Jenkins configuration"
  git clone $ORIGIN -b jenkins-backup $JENKINS_HOME
fi

java -jar jenkins.war &
