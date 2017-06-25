# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.provision :shell, :path => "mysql.sh", :privileged => false
  config.vm.provision :shell, :path => "bootstrap.sh", :privileged => false
  config.vm.provision :shell, :path => "mumble.sh", :privileged => false
  config.vm.provision :shell, :path => "zsh.sh", :privileged => false
  config.vm.provision :shell, :path => "git.sh", :privileged => false
  config.vm.provision :shell, :path => "src.sh", :privileged => false
  config.vm.provision :shell, :path => "stack.sh", :privileged => false
  config.vm.provision :shell, :path => "haskell-vim-now.sh", :privileged => false  # deps: stack
  # The update seems to trigger other packages that expect interactive installation,
  # so disabling for now.
  # config.vm.provision :shell, :path => "upgrade.sh", :privileged => false
  config.vm.network :forwarded_port, host: 8181, guest: 80
  config.vm.network :forwarded_port, host: 43306, guest: 3306

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
  end
  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/pair'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

    provider.image = 'ubuntu-16-04-x64'
    provider.region = 'sfo1'
    provider.size = '4GB'
    provider.token = ENV['DIGITAL_OCEAN_TOKEN_V2']
    provider.ssh_key_name = 'Vagrant'
  end
end
