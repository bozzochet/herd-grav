#!/bin/bash -l

bin/gpm selfupgrade -f

#this on the final server should be removed
bin/gpm install -y admin

bin/gpm install -y bibtexify

bin/gpm install -y consistent-backup-name

bin/gpm install -y pdf-js

bin/gpm install -y devtools

bin/gpm install -y page-inject

bin/gpm install -y cookieconsent

bin/gpm install -y github

bin/gpm install -y blackhole

bin/gpm install -y page-toc

bin/gpm update -y

# custom plugins
if [ ! -e user/plugins/de-capitalize-gitlab-links/ ]
	then
	cp -av de-capitalize-gitlab-links user/plugins/
fi
cd user/plugins/de-capitalize-gitlab-links/
../../../composer.phar update
