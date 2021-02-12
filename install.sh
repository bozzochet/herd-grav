#!/bin/bash

#taken from: https://learn.getgrav.org/16/basics/installation
composer install --no-dev -o
bin/grav install -y

#to install used plugins:
source ./install_plugins.sh
