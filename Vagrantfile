# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box      = 'ubuntu/trusty64'
  config.vm.hostname = 'rails-dev-box'

  config.vm.network :forwarded_port, guest: 4000, host: 8080
  config.vm.network :forwarded_port, guest: 2222, host: 443

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
end

