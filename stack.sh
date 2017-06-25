#!/usr/bin/env bash

echo "-----> Installing Stack"
curl -sSL https://get.haskellstack.org/ | sudo sh

echo "-----> Setting up GHC"
stack setup
