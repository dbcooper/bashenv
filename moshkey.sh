#!/bin/sh

# NOTE  This file has to be _sourced_ into the current environment

# Keychain setup from https://www.cyberciti.biz/faq/installing-keychain-manager-for-ssh-agent-on-centos-linux-6-7/
eval $(/usr/bin/keychain --eval --agents ssh id_rsa --timeout 360)
