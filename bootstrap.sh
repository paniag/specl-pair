#!/usr/bin/env bash

apt-get update -q
apt-get install gcc libgmp-dev alex happy curl libcurl4-gnutls-dev libpcre3-dev libffi-dev make python-software-properties vim ctags git tmux ruby xz-utils -y -q

GHC_VER=7.8.2
CABAL_VER=1.20.0.2

if hash ghc 2>/dev/null; then
  echo "-----> GHC detected"
else
  GHC_URL="http://www.haskell.org/ghc/dist/$GHC_VER/ghc-$GHC_VER-x86_64-unknown-linux-deb7.tar.xz"
  echo "-----> Downloading GHC $GHC_VER"
  curl --silent -L "$GHC_URL" | unxz | tar x -C /tmp
  cd /tmp/ghc-$GHC_VER
  echo "-----> Installing GHC $GHC_VER"
  ./configure
  make install
fi

if hash cabal 2>/dev/null; then
  echo "-----> Cabal detected"
else
  CABAL_URL="http://www.haskell.org/cabal/release/cabal-install-$CABAL_VER/cabal-install-$CABAL_VER.tar.gz"
  echo "-----> Downloading cabal-install $CABAL_VER"
  curl --silent -L "$CABAL_URL" | tar zx -C /tmp
  cd /tmp/cabal-install-$CABAL_VER
  echo "-----> Installing cabal-install $CABAL_VER"
  ./bootstrap.sh --global
fi

echo "-----> Saving system tmux.conf"
cp /vagrant/tmux.conf /etc

if hash wemux 2>/dev/null; then
  echo "-----> Wemux detected"
else
  echo "-----> Installing wemux"
  git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux
  ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux
  cp /vagrant/wemux.conf /usr/local/etc
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

echo "-----> Initializing bash profile"
echo "export PATH=$PATH:$HOME/bin ; wemux start" > $HOME/.bash_profile
