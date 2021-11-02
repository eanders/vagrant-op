# Open Path on Vagrant
This can be run with either a VirtualBox or Parallels provider.

```bash
gem uninstall vagant
brew install vagrant

vagrant plugin install vagrant-parallels
vagrant init bento/ubuntu-20.04

git clone git@github.com:eanders/vagrant-op.git op
```
Either clone or copy in your existing [HMIS Warehouse](http://github.com/greenriver/hmis-warehouse) and [CAS](http://github.com/greenriver/boston-cas) directories into the `op` folder created above.

Initialize with a VirtualBox provider
```bash
vagrant up
```

Initialize with a Parallels provider
```bash
vagrant up --provider="parallels"
```

Future starts can be run as
```bash
vagrant up
```

If you want both CAS and the warehouse to share a database server, you may want to add a `docker-compose-override.yml` to one of the installations that puts the db container on a different port
```yaml
version: '3.8'

services:
  db:
   ports:
     - 5432:5432
   command: ['postgres', '-c', 'max_connections=500', '-c', 'log_statement=all', '-c', 'port=5432']
```
