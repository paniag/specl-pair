#!/usr/bin/env bash

source /vagrant/.secret/root_password

MYSQL_VERSION=5.7

if hash mysql 2> /dev/null; then
  CURRENT_DISTRIB=`mysql --version | perl -pe 's/^.*Distrib\s+(\d+\.\d+).*$/$1/'`
  echo -n "Found "
  mysql --version
  if [ "${CURRENT_DISTRIB}" == "${MYSQL_VERSION}" ]; then
    echo "Matches target version ${MYSQL_VERSION}, skipping..."
    exit 0
  fi
  echo "Does not match target version ${MYSQL_VERSION}"
  echo "SKIPPING MYSQL INSTALLATION BECAUSE DIFFERENT VERSION ALREADY INSTALLED!!!!!"
  echo "SKIPPING MYSQL INSTALLATION BECAUSE DIFFERENT VERSION ALREADY INSTALLED!!!!!" >&2
  exit 0
fi

export DEBIAN_FRONTEND="noninteractive"

echo "-----> Installing MySQL ${MYSQL_VERSION}"
sudo apt-get update -q
sudo apt-get install -y -q debconf-utils
echo "mysql-server-${MYSQL_VERSION} mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}" | sudo debconf-set-selections
echo "mysql-server-${MYSQL_VERSION} mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}" | sudo debconf-set-selections
sudo apt-get update -q
sudo apt-get install -y -q \
  mysql-client-${MYSQL_VERSION} \
  mysql-sandbox \
  mysql-server-${MYSQL_VERSION} \
  mysql-workbench \

# Previous line intentionally left blank.
sudo service mysql restart
