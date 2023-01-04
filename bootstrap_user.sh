#!/usr/bin/env bash

echo "export AWS_VAULT_BACKEND=file" >> /home/vagrant/.bashrc
echo "export GPG_TTY=$(tty)" >> /home/vagrant/.bashrc
echo "export AWS_ACCESS_KEY_ID=unknown" >> /home/vagrant/.bashrc
echo "export AWS_SECRET_ACCESS_KEY=unknown" >> /home/vagrant/.bashrc
echo "export AWS_SESSION_TOKEN=unknown" >> /home/vagrant/.bashrc
echo "export AWS_SECURITY_TOKEN=unknown" >> /home/vagrant/.bashrc
echo "alias dcr='docker-compose run --rm'" >> /home/vagrant/.bashrc

# add keys so we don't need to enter the password always
echo "ssh-add" >> /home/vagrant/.bashrc

if [ ! -d /vagrant/boston-cas ]; then
  git clone git@github.com:greenriver/boston-cas.git /vagrant/boston-cas
  cp /vagrant/cas-docker-compose.override.yml /vagrant/boston-cas/docker-compose.override.yml
  cp /vagrant/boston-cas/.env.sample /vagrant/boston-cas/.env.local
  echo "RAILS_ENV=test" > /vagrant/boston-cas/.env.test
fi

if [ ! -d /vagrant/hmis-warehouse ]; then
  git clone git@github.com:greenriver/hmis-warehouse.git /vagrant/hmis-warehouse
  cp /vagrant/hmis-docker-compose.override.yml /vagrant/hmis-warehouse/docker-compose.override.yml
  cp /vagrant/hmis-warehouse/sample.env /vagrant/hmis-warehouse/.env.local
  openssl req -new -newkey rsa:2048 -sha256 -days 3650 -nodes -x509 \
    -keyout /vagrant/hmis-warehouse/docker/nginx-proxy/certs/dev.test.key \
    -out /vagrant/hmis-warehouse/docker/nginx-proxy/certs/dev.test.crt \
    -config /vagrant/openssl.cnf
fi

if [ ! -d /vagrant/sftp ]; then
  mkdir /vagrant/sftp
fi

ln -s /vagrant/boston-cas ~/boston-cas
ln -s /vagrant/hmis-warehouse ~/hmis-warehouse
ln -s /vagrant/hmis-frontend ~/hmis-frontend
ln -s /vagrant/deploy ~/deploy
ln -s /vagrant/sftp ~/sftp
mkdir -p ~/minio/data
mkdir -p ~/.minio/certs
cp ~/hmis-warehouse/docker/nginx-proxy/certs/dev.test.crt ~/.minio/certs/public.crt
cp ~/hmis-warehouse/docker/nginx-proxy/certs/dev.test.key ~/.minio/certs/private.key
sudo cp /vagrant/hmis-warehouse/docker/nginx-proxy/certs/dev.test.crt /usr/local/share/ca-certificates
sudo update-ca-certificates

source ~/.bashrc

gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm

cd ~/hmis-warehouse
rvm install "ruby-2.7.6"
gem install bundler:2.3.8
gem install overcommit
gem install aws-sdk-secretsmanager
gem install aws-sdk-ecr
gem install aws-sdk-elasticloadbalancingv2
overcommit --sign
bundle config build.nokogiri --use-system-libraries

mkdir ~/.aws
touch ~/.aws/config

ln -s /vagrant/localstack ~/localstack
python3 -m pip install localstack

# TODO:
# git credentials (and verification)
# Notes: you'll need to copy your gpg keys from the host (if you have them)
# Instructions for the github side are here: https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits
# git config commit.gpgsign true
# Will auto sign all commits
# https://gist.github.com/paolocarrasco/18ca8fe6e63490ae1be23e84a7039374 might help you solve:
# error: gpg failed to sign the data
# fatal: failed to write commit object

# aws-vault add openpath
