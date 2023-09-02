# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # note, prior to first boot, you need to
  # export VAGRANT_EXPERIMENTAL="disks"
  # vagrant plugin install vagrant-disksize
  # or the next line won't do anything
  config.vm.disk :disk, name: 'op-main', size: '60GB', primary: true
  config.vm.box = 'bento/ubuntu-22.04-arm64'
  config.vm.box_check_update = false

  config.vm.network 'forwarded_port', guest: 22, host: 2323
  config.ssh.port = 2323
  config.ssh.host = '127.0.0.1'
  config.ssh.forward_agent = true

  config.vm.network 'forwarded_port', guest: 5432, host: 8543, auto_correct: false
  config.vm.network 'forwarded_port', guest: 6379, host: 6380, auto_correct: false
  # config.vm.network 'forwarded_port', guest: 80, host: 80, auto_correct: false
  config.vm.network 'forwarded_port', guest: 443, host: 443, auto_correct: false
  config.vm.network 'forwarded_port', guest: 9000, host: 9000, auto_correct: false
  # enable for minio console
  # config.vm.network 'forwarded_port', guest: 9001, host: 9001, auto_correct: false
  # superset
  # config.vm.network 'forwarded_port', guest: 8088, host: 8088, auto_correct: false
  config.ssh.forward_agent = true
  config.vm.provider :parallels do |prl|
    prl.update_guest_tools = false
    prl.memory = 8192
    prl.cpus = 6
  end
  # config.vm.provider :virtualbox do |vb|
  #   vb.memory = 8192
  # end

  config.vm.provision :shell, path: 'bootstrap.sh'
  config.vm.provision :shell, path: 'bootstrap_user.sh', privileged: false
  config.vm.provision :shell, path: 'bootup.sh', run: :always
end
