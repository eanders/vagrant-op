#!/usr/bin/env bash

echo "export AWS_VAULT_BACKEND=file" >> /home/vagrant/.bashrc
echo "export GPG_TTY=$(tty)" >> /home/vagrant/.bashrc
echo "alias dcr='docker-compose run --rm'" >> /home/vagrant/.bashrc
# add keys so we don't need to enter the password always
echo "ssh-add" >> /home/vagrant/.bashrc
ln -s /vagrant/boston-cas ~/boston-cas
ln -s /vagrant/hmis-warehouse ~/hmis-warehouse

source ~/.bashrc

gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm

cd ~/hmis-warehouse
rvm install "ruby-2.7.4"

# TODO:
# git credentials (and verification)

sudo curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v4.2.0/aws-vault-linux-amd64
sudo chmod 755 /usr/local/bin/aws-vault
