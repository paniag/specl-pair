#!/usr/bin/env bash

echo '-----> Upgrading all packages'
sudo apt-get update -q && sudo apt-get upgrade -y -q
