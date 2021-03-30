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
		    if [[ "${WIKISPATH}/${i}/${j}/${k}" == *"Table-of-contents.md" ]]
		    then
			mkdir -p user/pages/${PART}/${j}
			echo "---" > user/pages/${PART}/${j}/item.md
			echo "body_classes: 'header-dark header-transparent'" >> user/pages/${PART}/${j}/item.md
			echo "hero_classes: 'text-light title-h1h2 overlay-dark-gradient hero-large parallax'" >> user/pages/${PART}/${j}/item.md
			echo "hero_image: mountain.jpg" >> user/pages/${PART}/${j}/item.md
			echo "---" >> user/pages/${PART}/${j}/item.md
			cat ${WIKISPATH}/${i}/${j}/${k} >> user/pages/${PART}/${j}/item.md
#			cp WikiTemplate/mountain.jpg user/pages/${PART}/${j}/
		    else
			mkdir -p user/pages/${PART}/${j}/${BASENAME}
			echo "---" > user/pages/${PART}/${j}/${BASENAME}/item.md
			echo "body_classes: 'header-dark header-transparent'" >> user/pages/${PART}/${j}/${BASENAME}/item.md
			echo "hero_classes: 'text-light title-h1h2 overlay-dark-gradient hero-large parallax'" >> user/pages/${PART}/${j}/${BASENAME}/item.md
			echo "hero_image: mountain.jpg" >> user/pages/${PART}/${j}/${BASENAME}/item.md
			echo "---" >> user/pages/${PART}/${j}/${BASENAME}/item.md
			cat ${WIKISPATH}/${i}/${j}/${k} >> user/pages/${PART}/${j}/${BASENAME}/item.md
#			cp WikiTemplate/mountain.jpg user/pages/${PART}/${j}/${BASENAME}/
		    fi
		fi
	    done
	else
#	    echo ${j}
	    #	    if [ "${j}" == "home.md" ]
	    if [ "${j}" == "index.md" ]
	    then
		./herd_wiki_template.sh ${PART} > item.md
		echo "" >> item.md
		cat ${WIKISPATH}/${i}/${j} >> item.md
		mkdir -p user/pages/${PART}/
		mv item.md user/pages/${PART}/
#		cp WikiTemplate/mountain.jpg user/pages/${PART}/
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
		cp ${WIKISPATH}/${i}/${j} user/pages/${PART}/${BASENAME}/item.md
	    fi
	fi
    done
done
