
Vagrant.require_plugin('vagrant-hostmanager')
Vagrant.require_plugin('vagrant-hostsupdater')

Vagrant.configure("2") do |config|
  config.vm.box = "wheezy"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-70rc1-x64-vbox4210.box"

  config.vm.network :private_network, ip: "10.23.101.22"
  config.ssh.forward_agent = true

  config.vm.hostname = "wall.dev"
  config.hostsupdater.aliases = ["www.wall.dev"]

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 512]
    v.customize ["modifyvm", :id, "--name", "wall"]
  end

  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
  config.vm.synced_folder "./", "/var/www", id: "vagrant-root" , :nfs => nfs_setting
  config.vm.provision :shell, :inline =>
    "if [[ ! -f /apt-get-run ]]; then sudo apt-get update && sudo touch /apt-get-run; fi"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = ".vagrant/manifests"
    puppet.module_path = ".vagrant/modules"
    puppet.options = [
        "--verbose"
    ]
  end
end
