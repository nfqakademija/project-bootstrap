# -*- mode: ruby -*-
# vi: set ft=ruby :
# Created by Simonas Šerlinskas
# All feedback welcome simonas.serlinskas@nfq.lt

###############################################################
###############################################################
###############################################################

#  Required at least Vagrant v. >=1.2.0
Vagrant.require_plugin('vagrant-hostsupdater')

Vagrant.configure("2") do |config|
  config.vm.box = "wheezy"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-70rc1-x64-vbox4210.box"

  config.vm.network :private_network, ip: "10.10.21.10"
    config.ssh.forward_agent = true

    config.vm.hostname = "nfqakademija.dev"
    config.hostsupdater.aliases = ["nfqakademija.dev"]

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "nfqakademija-box"]
  end

  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
  config.vm.synced_folder "./", "/var/www", id: "vagrant-root" , :nfs => nfs_setting
  config.vm.provision :shell, :inline =>
    "if [[ ! -f /apt-get-run ]]; then sudo apt-get update && sudo touch /apt-get-run; fi"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = ".vagrant/manifests"
    puppet.module_path = ".vagrant/modules"
    puppet.options = ['--verbose']
  end
end
