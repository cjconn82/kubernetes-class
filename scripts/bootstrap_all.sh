#!/bin/bash

YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)

echo "Configuring non-Ansible guest... $(hostname)"

if [[ ! -z $YUM_CMD ]]; then
  echo "Yum packager found."
  sudo yum -y install epel-release vim && sudo yum -y update
elif [[ ! -z $APT_GET_CMD ]]; then
  echo "APT packager found."
  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt-get install -y vim
else
  echo "error: Unknown packager"
  exit 1;
fi
