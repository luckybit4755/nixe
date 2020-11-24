#!/bin/bash	
# functions to do git things

gut() {
	local file=.gut.${RANDOM}.${RANDOM}.${RANDOM}.${RANDOM}.
	echo -e 'this file will go away after exiting the editor\n' > ${file}
	git status >> ${file}
	${EDITOR-vim} ${file}
	rm ${file}
}

gut_base() {
	local start=${PWD}
	for ((i=0;i<33;i++)) ; do
		if [ -d .git ] ; then
			echo ${PWD}
			break;
		fi
		if [ / = ${PWD} ] ; then
			break;
		fi
		cd ..
	done
	cd ${start}
}

gut_path() {
	local main=${MAIN-master}
	local arg

	local base=$( gut_base )
	local url=$( git config --get remote.origin.url | sed 's,:,/,;s,^.*@,https://,;s,\.git$,,' )
	for arg in ${*-.} ; do
		local path=$( readlink -f ${arg} )
		local relative=$( echo ${path} | sed "s,^${base},," )
		local branch=$( git status | head -1 | sed 's,.* ,,' )
		echo ${url}/tree/${branch}${relative} \
		| sed "s,/tree/${main}/,/blob/${main}/,;s,///,://,"
	done
}

gut_sup() {
	echo -----------------------------------------------------------------------------
	gut_path
	git status | awk 'NR<3{L[i++]=$0} END{ print L[0] " which is " L[1] }' | sed 's,Your branch is ,,'
	git branch -vv
	echo "Remotes:"
	git remote -v  | column -t | sed 's,^,> ,'
	echo -----------------------------------------------------------------------------
	git status | awk 'NR<4||/\(use "/||/^$/ {next} {print}'
	echo -----------------------------------------------------------------------------
}

