#!/bin/bash

ONLYTAG=1

WIKISPATH=Wikis
WIKIDEPLOYDIR=user/pages/wiki
WIKIDEPLOYDIRBASE=`basename ${WIKIDEPLOYDIR}`

mkdir -p $WIKISPATH

rm -Rf ${WIKISPATH}
#git clone git@git.recas.ba.infn.it:herd/HerdSoftware.wiki.git ${WIKISPATH}/master #master
#git clone https://wiki-webdoc-readrepo:CXVwDJEyNa7zYXhqDS7t@git.recas.ba.infn.it/herd/HerdSoftware.wiki.git ${WIKISPATH}/master #master
#git clone https://git.recas.ba.infn.it/herd/HerdSoftwareWiki.git ${WIKISPATH}/master #master
git clone https://wiki-webdoc-readrepo:2LScf6SCNrvUoxTojd8s@git.recas.ba.infn.it/herd/HerdSoftwareWiki.git ${WIKISPATH}/master #master

CURRENTDIR=`pwd`

cd $WIKISPATH/master

for i in `git tag | egrep '^[0-9]+\.[0-9]+\.[0-9]+$'` #to match only tags x.y.z, where x, y and z are numbers (even with two or more digits)
do 
    echo $i
    cp -a ../master ../$i
    cd ../$i
    git checkout $i &> /dev/null
    rm -Rf ./.git
    cd - &> /dev/null
done

if [[ "$ONLYTAG" != 1 ]]
then
    for i in `git branch -r | grep -v HEAD | grep -v master`
    do
	branch=${i#"origin/"}
	echo $branch
	cp -a ../master ../$branch
	cd ../$branch
	git checkout $branch &> /dev/null
	rm -Rf ./.git
	cd - &> /dev/null
    done
fi

cd $CURRENTDIR

rm -Rf ${WIKIDEPLOYDIR}

mkdir -p ${WIKIDEPLOYDIR}
./herd_wiki_template_choice.sh > item.md.choice
echo "<h3>" >> item.md.choice

for i in `ls -r ${WIKISPATH}/`
do
    #	echo ${i}
    WIKIVER=${i}
    #	    echo $WIKIVER
    WIKIVERDIR="v${WIKIVER}"
    if [[ "${WIKIVER}" == "master" ]]
    then
	echo "<br><a href=\"${WIKIDEPLOYDIRBASE}/${WIKIVERDIR}\"><i class=\"fa fa-code-fork\" aria-hidden=\"true\"></i> ${WIKIVER}</a>" >> item.md.choice
    else
	echo "<br><a href=\"${WIKIDEPLOYDIRBASE}/${WIKIVERDIR}\"><i class=\"fa fa-tag\" aria-hidden=\"true\"></i> ${WIKIVER}</a>" >> item.md.choice
    fi
#    rm -Rf ${WIKIDEPLOYDIR}/${WIKIVERDIR}
    mkdir -p ${WIKIDEPLOYDIR}/${WIKIVERDIR}
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
			mkdir -p ${WIKIDEPLOYDIR}/${WIKIVERDIR}/${j}
			./herd_wiki_template.sh ${WIKIVER} ${WIKIDEPLOYDIRBASE}/${WIKIVERDIR} > item.md
			cat ${WIKISPATH}/${i}/${j}/${k} >> item.md
			sed 's/%3A/-/' item.md > item.md.new
			mv item.md.new ${WIKIDEPLOYDIR}/${WIKIVERDIR}/${j}/item.md
			rm item.md
		    else
			mkdir -p ${WIKIDEPLOYDIR}/${WIKIVERDIR}/${j}/${BASENAME}
			./herd_wiki_template.sh ${WIKIVER} ${WIKIDEPLOYDIRBASE}/${WIKIVERDIR} > item.md
			cat ${WIKISPATH}/${i}/${j}/${k} >> item.md
			sed 's/%3A/-/' item.md > item.md.new
			mv item.md.new ${WIKIDEPLOYDIR}/${WIKIVERDIR}/${j}/${BASENAME}/item.md
			rm item.md
		    fi
		else
		    #		    echo ${WIKISPATH}/${i}/${j}/${k}
		    mkdir -p ${WIKIDEPLOYDIR}/${WIKIVERDIR}/${j}
		    cp -a ${WIKISPATH}/${i}/${j}/${k} ${WIKIDEPLOYDIR}/${WIKIVERDIR}/${j}/${k}
		fi
	    done
	else
#	    echo ${WIKISPATH}/${i}/${j}
#	    echo ${j}
	    #	    if [ "${j}" == "home.md" ]
	    if [ "${j}" == "index.md" ]
	    then
		mkdir -p ${WIKIDEPLOYDIR}/${WIKIVERDIR}/
		./herd_wiki_template.sh ${WIKIVER} ${WIKIDEPLOYDIRBASE}/${WIKIVERDIR} > item.md
		cat ${WIKISPATH}/${i}/${j} >> item.md
		sed 's/%3A/-/' item.md > item.md.new
		mv item.md.new ${WIKIDEPLOYDIR}/${WIKIVERDIR}/item.md
		rm item.md
	    elif [ "${j}" == "_sidebar.md" ]
	    then
		mkdir -p ${WIKIDEPLOYDIR}/${WIKIVERDIR}
		cp -a WikiTemplate/modules ${WIKIDEPLOYDIR}/${WIKIVERDIR}/
		cat ${WIKISPATH}/${i}/${j} > default.md
		sed 's/%3A/-/' default.md > wiki-sidebar.md
		mv wiki-sidebar.md ${WIKIDEPLOYDIR}/${WIKIVERDIR}/modules/sidebar/
		rm default.md
	    elif [ "${j}" == "Wanted.md" ]
	    then
		BASENAME=`basename ${WIKISPATH}/${i}/${j} .md`
#		echo $BASENAME
		mkdir -p ${WIKIDEPLOYDIR}/${WIKIVERDIR}/${BASENAME}
		./herd_wiki_template.sh ${WIKIVER} ${WIKIDEPLOYDIRBASE}/${WIKIVERDIR} > item.md
		cat ${WIKISPATH}/${i}/${j} >> item.md
		sed 's/%3A/-/' item.md > item.md.new
		mv item.md.new ${WIKIDEPLOYDIR}/${WIKIVERDIR}/${BASENAME}/item.md
		rm item.md
	    fi
	fi
    done
done

echo "</h3>" >> item.md.choice
mv item.md.choice ${WIKIDEPLOYDIR}/item.md
