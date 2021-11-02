# Open Path on Vagrant
This can be run with either a VirtualBox or Parallels provider.

```bash
gem uninstall vagant
brew install vagrant

vagrant plugin install vagrant-parallels

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

To access the web interface outside of the vagrant container, you'll need to add certificates for nginx-proxy [as noted in the warehouse networking setup](https://github.com/greenriver/hmis-warehouse/blob/production/docs/developer-networking.md#certificate) and then restart vagrant.


If you want both CAS and the warehouse to share a database server, you may want to add a `docker-compose.override.yml` to one of the warehouse installation that puts the db container on a different port. 
```yaml
version: '3.8'

services:
  db:
   ports:
     - 5432:5432
   command: ['postgres', '-c', 'max_connections=500', '-c', 'log_statement=all', '-c', 'port=5432']
```

Then add this to `docker-compose.override.yml` to CAS.
```yaml
services:
  db:
    ports:
      - 5433:5433
    command: ['postgres', '-c', 'max_connections=500', '-c', 'log_statement=all', '-c', 'port=5433']
  redis:
    ports:
      - 6378 # hide redis from the warehouse
```
