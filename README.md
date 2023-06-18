# Open Path on Vagrant
This can be run with either a VirtualBox or Parallels provider.

```bash
gem uninstall vagrant
brew install vagrant

vagrant plugin install vagrant-parallels

git clone git@github.com:eanders/vagrant-op.git op
```
Either copy in your existing [HMIS Warehouse](http://github.com/greenriver/hmis-warehouse) and [CAS](http://github.com/greenriver/boston-cas) directories into the `op` folder created above, or they will be cloned and a default configuration will be created.

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


Once Vagrant is up, `ssh` in and run the setup scripts:
```sh
vagrant ssh
cd hmis-warehouse
docker-compose run --rm shell bin/setup

cd ../boston-cas
docker-compose run --rm shell bin/setup
```

## Extra Steps for Parallels

Run this from inside the Vagrant box to ensure inotify can watch all files:

```sh
sudo sh -c "echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf"
sudo sysctl -p
```


# Parallels and Vagrant on Apple M1
Vagrant really doesn't like to be installed without VirtualBox. Since you can't install VirtualBox on M1 you can get around this by returning a valid known functioning version.

Place the following in `/usr/local/bin/VBoxManage` and then run `chmod 755 /usr/local/bin/VBoxManage`.

```
#!/usr/bin/env bash

echo "5.0.10"
```

Alteratively you can install from source and update `plugins/providers/virtualbox/driver/meta.rb#read_version` something like `return '5.0.10'`.

# Accessing the site

If everything worked as designed your site should now be available at [https://hmis-warehouse.dev.test](https://hmis-warehouse.dev.test).  Any mail that the site sends will be delivered to [MailHog](https://github.com/mailhog/MailHog) which is availble at [https://mail.hmis-warehouse.dev.test](https://mail.hmis-warehouse.dev.test). CAS should be available at [https://boston-cas.dev.test/](https://boston-cas.dev.test/).

To access the web interface outside of the vagrant container, you'll need to add certificates for nginx-proxy [as noted in the warehouse networking setup](https://github.com/greenriver/hmis-warehouse/blob/production/docs/developer-networking.md#certificate) and then restart vagrant. If you allowed vagrant to clone
and create a default configuration, the certificates will be created for you,
but you will still need to install them on your local machine.

# Resizing disks
With the Parallels Provider, it appears disks don't resize quite as seemlessly, but the "physical" disk grows.  In Ubuntu you can run:
```
sudo lvextend --size 58GB /dev/mapper/ubuntu--vg-ubuntu--lv
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```
Alternatively, you can make a "docker" disk.  Create a large disk in Parallels.  Then within the container
```
sudo su -
systemctl stop docker
mv /var/lib/docker /var/lib/docker-tmp
mkdir /var/lib/docker
chmod chmod 710 /var/lib/docker
fdisk /dev/sdb # Follow the steps to make a new primary partition
mkfs.ext4 /dev/sdb1
lsblk -f # this will tell you the UUID of the new partition
```
Add the following to /etc/fstab
```
/dev/disk/by-uuid/<<UUID>> /var/lib/docker ext4 defaults 0 1
#VAGRANT-BEGIN
```
Then:
```
mount /var/lib/docker
rsync -a /var/lib/docker-tmp/* /var/lib/docker/
systemctl start docker
exit
df -h # should now show the new mount with some data in it
```

# Database overrides

If you want both CAS and the warehouse to share a database server, you may want to add a `docker-compose.override.yml` to one of the warehouse installation that puts the db container on a different port.

If you're using vagrant, you can skip this step. This is the default if you allowed vagrant to create a configuration.


Add this to `docker-compose.override.yml` in HMIS Warehouse:
```yaml
version: '3.8'

services:
  db:
   ports:
     - 5432:5432
   command: ['postgres', '-c', 'max_connections=500', '-c', 'log_statement=all', '-c', 'port=5432']
```

Then add this to `docker-compose.override.yml` in CAS:
```yaml
version: '3.8'

services:
  db:
    ports:
      - 5433:5433
    command: ['postgres', '-c', 'max_connections=500', '-c', 'log_statement=all', '-c', 'port=5433']
  redis:
    ports:
      - 6378 # hide redis from the warehouse
```

# Database backups

The database is the main set of data that is currently only stored within a docker volume.  To prevent losing your data you should back it up.  This is one way:
```
docker exec -t hmis-warehouse-db pg_dumpall -c -U postgres > var/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
```
Then to restore:
```
cat var/your_dump.sql | docker exec -i hmis-warehouse-db psql -U postgres
```
