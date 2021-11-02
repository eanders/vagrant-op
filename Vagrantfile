# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # note, prior to first boot, you need to
  # export VAGRANT_EXPERIMENTAL="disks"
  # or the next line won't do anything
  config.vm.disk :disk, name: 'op-main', size: '60GB', primary: true
  config.vm.box = 'bento/ubuntu-20.04'
  config.vm.box_check_update = false
  config.vm.network 'forwarded_port', guest: 5432, host: 8543
  config.vm.network 'forwarded_port', guest: 6379, host: 6380
  config.vm.network 'forwarded_port', guest: 80, host: 80
  config.vm.network 'forwarded_port', guest: 443, host: 443
  config.ssh.forward_agent = true
  config.vm.provider :parallels do |prl|
    prl.update_guest_tools = true
    prl.memory = 8192
    prl.cpus = 4
  end
  config.vm.provider :virtualbox do |vb|
    vb.memory = 8192
  end

  config.vm.provision :shell, path: 'bootstrap.sh'
  config.vm.provision :shell, path: 'bootstrap_user.sh', privileged: false
  config.vm.provision :shell, path: 'bootup.sh', run: :always
end
