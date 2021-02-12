#!/bin/bash

#taken from: https://learn.getgrav.org/16/basics/installation
composer install --no-dev -o
bin/grav install

#to install used plugins:

#this on the final server should be not needed
bin/gpm install admin

bin/gpm install bibtexify

bin/gpm install consistent-backup-name

bin/gpm install facebook-feed

bin/gpm install pdf-js

bin/gpm install devtools

bin/gpm install page-inject
