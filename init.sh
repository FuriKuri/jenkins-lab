#!/bin/bash

sudo chown jenkins:jenkins /var/jenkins_home/

if [ ! -d "/var/jenkins_home/jobs" ]; then
  cp -r /usr/share/jenkins/jobs /var/jenkins_home/jobs
fi

if [ ! -d "/var/jenkins_home/plugins" ]; then
  /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
fi