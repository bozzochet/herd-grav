#!/bin/bash

#taken from: https://learn.getgrav.org/16/basics/installation

#composer install --no-dev -o
./install_composer.sh
./composer.phar install --no-dev -o

bin/grav install

#to install used plugins:
./install_plugins.sh
./remove_plugins.sh

#to download the wiki repo and install the corresponding pages
./clone_wiki_and_link.sh
