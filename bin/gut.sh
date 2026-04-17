#!/bin/bash	

export JUNK='(gradle.properties)'

_gg_main() {
	local tmp=/tmp/.gut.tmp.${USER} 
	git status > ${tmp} || return ${?}

	_gg_line
	grep -w branch ${tmp}

	# updated files
	local modified=$(awk '/^\t*modified: */ {print $NF}' ${tmp} | egrep -v ${JUNK})
	if [ "" != "${modified}" ] ; then
		echo -e "\ngit commit -m 'xxx'\n${modified}"

		local with_tabs=$(grep -l '\t' ${modified} | sed 's,^,- ,')
		if [ "" != "${with_tabs}" ] ; then
			_gg_line
			echo -e "The following have tabs:\n${with_tabs}"
		fi

		_gg_line

		echo 
		git diff ${modified}
	fi
	
	# new files

	local new=$(_gg_new_files ${tmp})
	if [ "" != "${new}" ] ; then
		_gg_line
		echo -e "git add\n${new}"
	fi

	# tmi

	if [ "TMI" = "${TMI}" ] ; then
		_gg_line
		cat ${tmp}
	fi

	_gg_line
	rm ${tmp}
}

_gg_line() {
	printf "%${1-121}s\n" "" | tr ' ' '-'
}

_gg_new_files() {
	local tmp=${1} ; shift
	for file in $( 
		awk '
			/to include in what will be committed/ {next}
			/\/\.[^\/]*\.sw[p]/ { next}
			K && 1 != length($1) { print }
			/^$/ {K = 0}
			/Untracked files:/ {K=1}
		' ${tmp}
	) ; do 
		if [ -h "${file}" ] ; then
			continue
		fi
		echo ${file}
	done
}


_gg_main ${*}
