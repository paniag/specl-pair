#!/usr/bin/env bash

source /vagrant/.secret/mysql/root_password

MYSQL_VERSION=5.7

echo "-----> Installing MySQL (non-interactively)"
echo "mysql-server-${MYSQL_VERSION} mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}" | sudo debconf-set-selections
echo "mysql-server-${MYSQL_VERSION} mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}" | sudo debconf-set-selections
sudo apt-get update -q
sudo apt-get install -y -q \
  mysql-client-${MYSQL_VERSION} \
  mysql-sandbox \
  mysql-server-${MYSQL_VERSION} \
  mysql-workbench \

# Previous line intentionally left blank.
sudo service mysql restart
