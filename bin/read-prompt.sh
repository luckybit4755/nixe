#!/bin/bash	

_read_prompt_main() {
	for file in ${*} ; do
		identify -verbose ${file}| fgrep -A10 Properties
	done
}

_read_prompt_old_main() {
	local B=${B-2}
	for file in ${*} ; do
		echo ${file} \
		| sed 's,\?.*,,;s,.*file=,,;s,^[a-z]*://,,' \
		| xargs strings \
		| grep -B${B} ^Steps:
	done
}


_read_prompt_main ${*}
