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
		    #ls -d ${WIKISPATH}/${i}/${j}/${k}
		    BASENAME=`basename ${WIKISPATH}/${i}/${j}/${k} .md`
#		    echo $BASENAME
		    BASENAME=`echo $BASENAME | sed 's/:/_/'`
#		    echo $BASENAME
		    if [[ "${WIKISPATH}/${i}/${j}/${k}" == *"Table-of-contents.md" ]]
		    then
			mkdir -p user/pages/${PART}/${j}
			./herd_wiki_template.sh ${PART} > item.md
			cat ${WIKISPATH}/${i}/${j}/${k} >> item.md
			sed 's/%3A/_/' item.md > item.md.new
			mv item.md.new user/pages/${PART}/${j}/item.md
		    else
			mkdir -p user/pages/${PART}/${j}/${BASENAME}
			./herd_wiki_template.sh ${PART} > item.md
			cat ${WIKISPATH}/${i}/${j}/${k} >> item.md
			sed 's/%3A/_/' item.md > item.md.new
			mv item.md.new user/pages/${PART}/${j}/${BASENAME}/item.md
		    fi
		fi
	    done
	else
#	    echo ${j}
	    #	    if [ "${j}" == "home.md" ]
	    if [ "${j}" == "index.md" ]
	    then
		mkdir -p user/pages/${PART}/
		./herd_wiki_template.sh ${PART} > item.md
		cat ${WIKISPATH}/${i}/${j} >> item.md
		mv item.md user/pages/${PART}/
	    elif [ "${j}" == "_sidebar.md" ]
	    then
		mkdir -p user/pages/${PART}
		cp -a WikiTemplate/modules user/pages/${PART}/
		cat ${WIKISPATH}/${i}/${j} > default.md
		mv default.md user/pages/${PART}/modules/sidebar/
	    elif [ "${j}" == "Wanted.md" ]
	    then
		BASENAME=`basename ${WIKISPATH}/${i}/${j} .md`
#		echo $BASENAME
		mkdir -p user/pages/${PART}/${BASENAME}
		./herd_wiki_template.sh ${PART} > item.md
		cat ${WIKISPATH}/${i}/${j} >> item.md
		mv item.md user/pages/${PART}/${BASENAME}/
	    fi
	fi
    done
done
