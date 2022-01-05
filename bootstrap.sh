#!/usr/bin/env bash

mkdir -p /home/vagrant/.ssh
ssh-keyscan -H github.com >> /home/vagrant/.ssh/known_hosts
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod -R 700 /home/vagrant/.ssh

echo '127.0.0.1 host.docker.internal' >> /etc/hosts

apt-get update
apt-get -y install docker.io gnupg2 postgresql-client-common libpq-dev libmagic-dev unzip ruby-curb freetds-dev libicu-dev libcurl4-gnutls-dev

curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-aarch64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

usermod -aG docker vagrant

cd docker/nginx-proxy
docker network create nginx-proxy

gem install bundler:1.17.3
gem install bundler:2.2.30
bundle update --bundler

curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v6.3.1/aws-vault-linux-arm64
chmod 755 /usr/local/bin/aws-vault
