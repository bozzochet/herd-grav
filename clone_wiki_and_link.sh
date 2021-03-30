#!/bin/bash

WIKISPATH=Wikis

mkdir -p $WIKISPATH

rm -Rf ${WIKISPATH}/vdev
#git clone git@git.recas.ba.infn.it:herd/HerdSoftware.wiki.git ${WIKISPATH}/vdev #master
#git clone https://wiki-webdoc-readrepo:CXVwDJEyNa7zYXhqDS7t@git.recas.ba.infn.it/herd/HerdSoftware.wiki.git ${WIKISPATH}/vdev #master
#git clone https://git.recas.ba.infn.it/herd/HerdSoftwareWiki.git ${WIKISPATH}/vdev #master
git clone https://wiki-webdoc-readrepo:CXVwDJEyNa7zYXhqDS7t@git.recas.ba.infn.it/herd/HerdSoftwareWiki.git ${WIKISPATH}/vdev #master

#PART=01.blog

for i in `ls ${WIKISPATH}/`
do
    #	echo ${i}
    PART=${i}
    rm -Rf user/pages/${PART}
    #	    echo $PART
    for j in `ls ${WIKISPATH}/${i}`
    do
#	echo ${WIKISPATH}/${i}/${j}
	if [ -d ${WIKISPATH}/${i}/${j} ]
	then
	    for k in `ls ${WIKISPATH}/${i}/${j}`
	    do
#		echo ${WIKISPATH}/${i}/${j}/${k}
		if [[ "${WIKISPATH}/${i}/${j}/${k}" == *".md" ]]
		then
#		    ls -d ${WIKISPATH}/${i}/${j}/${k}
		    BASENAME=`basename ${WIKISPATH}/${i}/${j}/${k} .md`
		    mkdir -p user/pages/${PART}/${j}/${BASENAME}
		    cp ${WIKISPATH}/${i}/${j}/${k} user/pages/${PART}/${j}/${BASENAME}/item.md
		fi
	    done
	else
#	    if [ "${j}" == "home.md" ]
	    if [ "${j}" == "index.md" ]
	    then
		./herd_wiki_template.sh ${PART} > item.md
		echo "" >> item.md
		cat ${WIKISPATH}/${i}/${j} >> item.md
		mkdir -p user/pages/${PART}/
		mv -v item.md user/pages/${PART}/
		cp -v WikiTemplate/mountain.jpg user/pages/${PART}/
	    else if [ "${j}" == "_sidebar.md" ]
		 then
		     mkdir -p user/pages/${PART}
		     cp -a  WikiTemplate/modules user/pages/${PART}/
		     cat ${WIKISPATH}/${i}/${j} > default.md
		     mv -v default.md user/pages/${PART}/modules/sidebar/
		 fi
	    fi
	fi
    done
done
