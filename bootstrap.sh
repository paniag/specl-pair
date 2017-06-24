#!/usr/bin/env bash

BASE_PKGS='alex ctags curl fail2ban gcc git happy libcurl4-gnutls-dev libffi-dev libgmp-dev libpcre3-dev libpq-dev make postgresql python-software-properties ruby tmux ufw vim vim-scripts xz-utils zsh'
SPECL_PKGS='apache2 apache2-doc mysql-client mysql-sandbox mysql-server mysql-workbench php php-xdebug vnc4server vncsnapshot xvnc4viewer' # netbeans

PKGS="${BASE_PKGS} ${SPECL_PKGS}"

echo "-----> Installing Packages"
apt-get update -q
apt-get install -y -q ${PKGS}

echo "-----> Installing Stack"
curl -sSL https://get.haskellstack.org/ | sh

echo "-----> Setting up GHC"
stack setup

echo "-----> Saving system tmux.conf"
cp /vagrant/config/tmux.conf /etc

if hash wemux 2>/dev/null; then
  echo "-----> Wemux detected"
else
  echo "-----> Installing wemux"
  git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux
  ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux
  cp /vagrant/config/wemux.conf /usr/local/etc
fi

if hash gh-auth 2>/dev/null; then
  echo "-----> github-auth detected"
else
  echo "-----> Installing Github key-based auth"
  gem install github-auth
fi

echo "-----> Adding pairing scripts"
mkdir -p $HOME/bin
cp /vagrant/user-scripts/* $HOME/bin

echo "-----> Creating user 'friend'"
adduser friend
echo "wemux pair; exit" > /home/friend/.bash_profile

echo "-----> Firewalling everything except SSH and Mumble"
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 64738
ufw --force enable

echo "-----> Hardening OpenSSH"
cp /vagrant/config/sshd_config /etc/ssh/sshd_config

VAGRANT_SSH=/home/vagrant/.ssh
SSHDIR=/vagrant/.secret/ssh
if [ -x "${SSHDIR}/id_rsa" ]; then
  echo "-----> Add SSH key (RSA)"
  mkdir -p ${VAGRANT_SSH}
  chmod 0700 ${VAGRANT_SSH}
  cp ${SSHDIR}/github.id_rsa ${VAGRANT_SSH}/
  chmod 0600 ${VAGRANT_SSH}/github.id_rsa
  chown -R vagrant:vagrant ${VAGRANT_SSH}
  sudo -u vagrant ssh-agent -s
  sudo -u vagrant ssh-add ${VAGRANT_SSH}/github.id_rsa
fi
