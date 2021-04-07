#!/bin/bash

WIKISPATH=Wikis

mkdir -p $WIKISPATH

rm -Rf ${WIKISPATH}/vdev
#git clone git@git.recas.ba.infn.it:herd/HerdSoftware.wiki.git ${WIKISPATH}/vdev #master
#git clone https://wiki-webdoc-readrepo:CXVwDJEyNa7zYXhqDS7t@git.recas.ba.infn.it/herd/HerdSoftware.wiki.git ${WIKISPATH}/vdev #master
#git clone https://git.recas.ba.infn.it/herd/HerdSoftwareWiki.git ${WIKISPATH}/vdev #master
git clone https://wiki-webdoc-readrepo:2LScf6SCNrvUoxTojd8s@git.recas.ba.infn.it/herd/HerdSoftwareWiki.git ${WIKISPATH}/vdev #master

#PART=01.blog

for i in `ls ${WIKISPATH}/`
do
    #	echo ${i}
    WIKIVER=${i}
    #	    echo $WIKIVER
    rm -Rf user/pages/${WIKIVER}
    mkdir -p user/pages/${WIKIVER}
    for j in `ls ${WIKISPATH}/${i}`
    do
#	echo ${WIKISPATH}/${i}/${j}
	if [ -d ${WIKISPATH}/${i}/${j} ]
	then
#	    echo ${WIKISPATH}/${i}/${j}
	    for k in `ls ${WIKISPATH}/${i}/${j}`
	    do
#		echo ${WIKISPATH}/${i}/${j}/${k}
		if [[ "${WIKISPATH}/${i}/${j}/${k}" == *".md" ]]
		then
		    #ls -d ${WIKISPATH}/${i}/${j}/${k}
		    BASENAME=`basename ${WIKISPATH}/${i}/${j}/${k} .md`
#		    echo $BASENAME
		    BASENAME=`echo $BASENAME | sed 's/:/-/'`
#		    echo $BASENAME
		    if [[ "${WIKISPATH}/${i}/${j}/${k}" == *"Table-of-contents.md" ]]
		    then
			mkdir -p user/pages/${WIKIVER}/${j}
			./herd_wiki_template.sh ${WIKIVER} > item.md
			cat ${WIKISPATH}/${i}/${j}/${k} >> item.md
			sed 's/%3A/-/' item.md > item.md.new
			mv item.md.new user/pages/${WIKIVER}/${j}/item.md
			rm item.md
		    else
			mkdir -p user/pages/${WIKIVER}/${j}/${BASENAME}
			./herd_wiki_template.sh ${WIKIVER} > item.md
			cat ${WIKISPATH}/${i}/${j}/${k} >> item.md
			sed 's/%3A/-/' item.md > item.md.new
			mv item.md.new user/pages/${WIKIVER}/${j}/${BASENAME}/item.md
			rm item.md
		    fi
		else
		    #		    echo ${WIKISPATH}/${i}/${j}/${k}
		    mkdir -p user/pages/${WIKIVER}/${j}
		    cp -a ${WIKISPATH}/${i}/${j}/${k} user/pages/${WIKIVER}/${j}/${k}
		fi
	    done
	else
#	    echo ${WIKISPATH}/${i}/${j}
#	    echo ${j}
	    #	    if [ "${j}" == "home.md" ]
	    if [ "${j}" == "index.md" ]
	    then
		mkdir -p user/pages/${WIKIVER}/
		./herd_wiki_template.sh ${WIKIVER} > item.md
		cat ${WIKISPATH}/${i}/${j} >> item.md
		sed 's/%3A/-/' item.md > item.md.new
		mv item.md.new user/pages/${WIKIVER}/item.md
		rm item.md
	    elif [ "${j}" == "_sidebar.md" ]
	    then
		mkdir -p user/pages/${WIKIVER}
		cp -a WikiTemplate/modules user/pages/${WIKIVER}/
		cat ${WIKISPATH}/${i}/${j} > default.md
		sed 's/%3A/-/' default.md > wiki-sidebar.md
		mv wiki-sidebar.md user/pages/${WIKIVER}/modules/sidebar/
		rm default.md
	    elif [ "${j}" == "Wanted.md" ]
	    then
		BASENAME=`basename ${WIKISPATH}/${i}/${j} .md`
#		echo $BASENAME
		mkdir -p user/pages/${WIKIVER}/${BASENAME}
		./herd_wiki_template.sh ${WIKIVER} > item.md
		cat ${WIKISPATH}/${i}/${j} >> item.md
		sed 's/%3A/-/' item.md > item.md.new
		mv item.md.new user/pages/${WIKIVER}/${BASENAME}/item.md
		rm item.md
	    fi
	fi
    done
done
