# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Set fqdn
  config.vm.hostname = 'vps.robhoward.local'

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  #config.vm.box_url = "http://dl.dropbox.com/u/11342885/oneiric32.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "33.33.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  #config.vm.forward_port 80, 8080

  # Website development
  config.vm.synced_folder "./devkdesigns", "/srv/devkdesigns.com"

  # Share in Puppet dirs manually.
  config.vm.synced_folder "./puppet/files", "/etc/puppet/files"
  config.vm.synced_folder "./puppet/hiera", "/etc/puppet/hiera"

  # Update Puppet to 3.x
  config.vm.provision :shell do |shell|
    shell.path = 'shell/ensure-puppet3.sh'
  end

  # Kick off Puppet provisioning itself
  config.vm.provision :puppet do |puppet|
    puppet.module_path    = 'puppet/modules'
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file  = "site.pp"
    puppet.options = [
      '--hiera_config /etc/puppet/hiera/hiera.yaml',
      '--fileserverconfig=/vagrant/puppet/fileserver.conf',
    ]
  end
end
