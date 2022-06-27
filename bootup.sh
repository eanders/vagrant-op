#!/usr/bin/env bash

cd /vagrant/hmis-warehouse/docker/nginx-proxy
docker-compose up -d
cd /vagrant/hmis-warehouse
docker-compose up -d
cd /vagrant/boston-cas
docker-compose up -d
# cd openstack
# docker-compose up -d
