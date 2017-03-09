# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

if File.file?('.vagrant/vagrant.yml')
  SETTINGS_FILE = ENV['SETTINGS_FILE'] || '.vagrant/vagrant.yml'
else
  SETTINGS_FILE = ENV['SETTINGS_FILE'] || 'vagrant.yml'
end

require 'yaml'

SETTINGS = YAML.load_file SETTINGS_FILE
BOX_NAME = SETTINGS['default']['box']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = BOX_NAME
  config.vm.box_url = SETTINGS['default']['box_url'] if SETTINGS['default'].has_key?('box_url')
  config.vm.provider "virtualbox" do |v|
    v.memory = SETTINGS['default']['memory']
    v.cpus = SETTINGS['default']['cpus']
    v.gui = false
  end

  config.vbguest.auto_update = SETTINGS['default']['vbguest_auto_update']
  if SETTINGS['default'].has_key?('ca_certificates_enabled')
    config.ca_certificates.enabled = SETTINGS['default']['ca_certificates_enabled']

    if ARGV.include?('up') || ARGV.include?('provision')
      # Run vagrant-ca-certificates plugin
      # printf "Running the vagrant-ca-certificates plugin: %s\n", Dir.glob(SETTINGS['default']['ca_certificates_certs'])
      config.ca_certificates.certs = Dir.glob(SETTINGS['default']['ca_certificates_certs'])
    end

    config.vm.box_download_ca_cert = SETTINGS['default']['box_download_ca_cert']
  end

  if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    config.vm.synced_folder '.', '/vagrant', mount_options: ['dmode=700,fmode=600'], type: 'virtualbox'
  else
    config.vm.synced_folder '.', '/vagrant'
  end

  SETTINGS['vms'].each do |name, vm|
    config.vm.define name do |c|
      c.vm.hostname = "#{name}"
      c.vm.network 'private_network', ip: vm['ip_address']
      c.vm.provision :shell, path: vm['bootstrap_script'], privileged: false
      if vm.has_key?('ansible_playbook')
        c.vm.provision :shell, inline: vm['ansible_playbook'], privileged: false
      end

      if vm.has_key?('memory') || vm.has_key?('cpus')
        c.vm.provider "virtualbox" do |v|
          v.memory = vm['memory'] if vm.has_key?('memory')
          v.cpus = vm['cpus'] if vm.has_key?('cpus')
        end
      end
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
