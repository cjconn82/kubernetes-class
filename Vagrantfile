# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "geerlingguy/centos7"
  if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"], type: "virtualbox"
  else
    config.vm.synced_folder ".", "/vagrant"
  end

  (1..3).each do |i|
    config.vm.define "minion#{i}" do |d|
      d.vm.hostname = "minion#{i}"
      d.vm.network "private_network", ip: "10.100.198.20#{i}"
      d.vm.provision :shell, path: "scripts/bootstrap_all.sh", privileged: false
      d.vm.provider "virtualbox" do |v|
        v.memory = 512
        v.gui = false
      end
    end
  end

  config.vm.define "master" do |d|
    d.vm.hostname = "master"
    d.vm.network "private_network", ip: "10.100.198.200"
    d.vm.network "forwarded_port", guest: 2379, host: 2379
    d.vm.network "forwarded_port", guest: 8080, host: 18080
    d.vm.network "forwarded_port", guest: 10250, host: 10250
    d.vm.provision :shell, path: "scripts/bootstrap_ansible.sh", privileged: false
    d.vm.provision :shell, inline: "ansible-playbook /vagrant/ansible/plays/k8s-setup.yml", privileged: false
    d.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.gui = false
    end
  end

#  if Vagrant.has_plugin?("vagrant-cachier")
#    config.cache.scope = :box
#  end
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled=true
    config.hostmanager.manage_guest=true
    config.hostmanager.ignore_private_ip=false
    config.hostmanager.include_offline=true
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
    config.vbguest.no_install = false
    config.vbguest.no_remote = true
  end
end
