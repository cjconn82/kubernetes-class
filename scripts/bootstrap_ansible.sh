#!/bin/bash

set -e

echo "Installing Ansible..."
sudo yum -y update
sudo yum -y install epel-release
sudo yum update repolist
sudo yum -y install ansible vim

sudo cp /etc/ansible/ansible.cfg{,.orig}
sudo cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg
