#!/bin/bash -l

bin/gpm selfupgrade -f

#this on the final server should be removed
#bin/gpm install -y admin
# if put here, even if then removed, seems that the remove is not working once you first login via admin and then send another `#bin/gpm remove -y admin`

bin/gpm install -y bibtexify

bin/gpm install -y consistent-backup-name

bin/gpm install -y pdf-js

bin/gpm install -y devtools

bin/gpm install -y page-inject

bin/gpm install -y cookieconsent

bin/gpm install -y github

bin/gpm install -y blackhole

bin/gpm install -y page-toc

bin/gpm install -y markdown-details

bin/gpm update -y

# custom plugins
if [ ! -e user/plugins/de-capitalize-gitlab-links/ ]
then
    cd user/plugins/
    ln -s ../../de-capitalize-gitlab-links ./
    #    cp -av de-capitalize-gitlab-links user/plugins/
    cd -
fi
cd de-capitalize-gitlab-links/
../composer.phar update
cd ..

# hacked plugins
if [ -e user/plugins/markdown-details/ ]
then
    cd user/plugins/markdown-details/
    ln -sf ../../../markdown-details-hack/markdown-details.php ./
    cd -
fi
