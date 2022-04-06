#!/bin/bash	

export EXTENSIONS="js|java|py|php|sh|awk"

_code_watcher_main() {
	local stamp=33
	local tmp=/tmp/.cw-${USER}-$( pwd | sha256sum  | awk '{print $1}' ).txt

	while true ; do
		local nu=$( _code_watcher_timestamp )
		if [ "${nu}" = "${stamp}" ] ; then
			echo that is boring >/dev/null
		else
			stamp=${nu}

			reset
			clear
			echo "update detected at ($(date)), running ${*}"
			printf "%${COLUMNS}s\n" "" | sed 's, ,-,g'
			time ${*} 2>&1 | tee ${tmp}
			printf "%${COLUMNS}s\n" "" | sed 's, ,-,g'
		fi
		sleep 1
	done
}

_code_watcher_timestamp() {
	_code_watcher_find | xargs -n 1 date -r
}

# https://unix.stackexchange.com/questions/15308/how-to-use-find-command-to-search-for-multiple-extensions
_code_watcher_find() {
	find . \( \
		   -path ./.git \
		-o -path ./node_modules \
		-o -path ./vendor \
	\) -prune -o -type f  \
	| egrep '\.('${EXTENSIONS}')$' 
}

_code_watcher_main ${*}
