#!/usr/bin/env bash

BASE_PKGS='alex ctags curl fail2ban gcc git happy libcurl4-gnutls-dev libffi-dev libgmp-dev libpcre3-dev libpq-dev make postgresql python-software-properties ruby tmux ufw vim vim-scripts xz-utils zsh'
SPECL_PKGS='apache2 apache2-doc php php-xdebug vnc4server vncsnapshot xvnc4viewer' # netbeans

PKGS="${BASE_PKGS} ${SPECL_PKGS}"

echo "-----> Installing Packages"
echo "PKGS='${PKGS}'"
sudo apt-get update -q
sudo apt-get install -y -q ${PKGS}

echo "-----> Saving system tmux.conf"
sudo cp /vagrant/config/tmux.conf /etc

if hash wemux 2> /dev/null; then
  echo "-----> Wemux detected"
else
  echo "-----> Installing wemux"
  sudo git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux
  sudo ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux
  sudo cp /vagrant/config/wemux.conf /usr/local/etc
fi

if hash gh-auth 2>/dev/null; then
  echo "-----> github-auth detected"
else
  echo "-----> Installing Github key-based auth"
  sudo gem install github-auth
fi

echo "-----> Adding pairing scripts"
sudo mkdir -p /root/bin
sudo cp /vagrant/user-scripts/* /root/bin

echo "-----> Creating user 'friend'"
sudo adduser friend
echo "wemux pair; exit" | sudo -u friend tee /home/friend/.bash_profile > /dev/null
sudo -u friend chmod 0644 /home/friend/.bash_profile

echo "-----> Firewalling everything except SSH and Mumble"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 3306
sudo ufw allow 64738
sudo ufw --force enable

echo "-----> Hardening OpenSSH"
sudo cp /vagrant/config/sshd_config /etc/ssh/sshd_config
sudo service ssh reload

KEYDIR=/vagrant/.secret/ssh
if [ -x "${KEYDIR}/github.id_rsa" ]; then
  echo "-----> Add SSH key (RSA)"
  mkdir -p ${HOME}/.ssh
  chmod 0700 ${HOME}/.ssh
  cp ${KEYDIR}/github.id_rsa ${HOME}/.ssh/
  chmod 0600 ${HOME}/.ssh/github.id_rsa
  cp ${KEYDIR}/github.id_rsa.pub ${HOME}/.ssh/
  chmod 0644 ${HOME}/.ssh/github.id_rsa.pub
  ssh-agent -s
  ssh-add ${HOME}/.ssh/github.id_rsa.pub
fi
