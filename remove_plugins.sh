#!/bin/bash -l

bin/gpm uninstall -y facebook-feed

bin/gpm uninstall -y form

bin/gpm uninstall -y login

bin/gpm uninstall -y email

bin/gpm uninstall -y flex-objects

#this on the final server should be removed
bin/gpm uninstall -y admin

