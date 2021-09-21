#!/usr/bin/env bash

echo "export AWS_VAULT_BACKEND=file" >> /home/vagrant/.bashrc
echo "export GPG_TTY=$(tty)" >> /home/vagrant/.bashrc
echo "alias dcr='docker-compose run --rm'" >> /home/vagrant/.bashrc
# add keys so we don't need to enter the password always
echo "ssh-add" >> /home/vagrant/.bashrc

gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.bashrc
rvm install "ruby-2.7.4"
gem install bundler:1.17.3
gem install bundler:2.2.26
bundle update --bundler

# TODO:
# git credentials (and verification)

sudo curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v4.2.0/aws-vault-linux-amd64
sudo chmod 755 /usr/local/bin/aws-vault
