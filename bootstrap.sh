#!/usr/bin/env bash

mkdir -p /home/vagrant/.ssh
ssh-keyscan -H github.com >> /home/vagrant/.ssh/known_hosts
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod -R 700 /home/vagrant/.ssh

echo '127.0.0.1 host.docker.internal' >> /etc/hosts

apt-get -y install docker.io gnupg2 postgresql-client-common libpq-dev libmagic-dev unzip ruby-curb freetds-dev libicu-dev libcurl4-gnutls-dev

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

usermod -aG docker vagrant

cd docker/nginx-proxy
docker network create nginx-proxy

gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
