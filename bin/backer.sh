#!/bin/bash	

export BACK=${HOME}/data/backup

_backer_main() {
	now=$( date +"%Y.%m.%d.%H.%M.%S" )

	mkdir -p ${BACK}

	local args=${*}	
	if [ 0 = ${#} ] ; then 
		local last=$( ls -tr | tail -1 )
		if [[ ${last} == bak-* ]] ; then
			echo "not backing up ${last}"
			return
		else
			args=${last}
		fi
	fi

	for file in ${args} ; do 
		local digest=$(_backer_digest ${file})
		local bak="${BACK}/bak-${digest}-${now}-${file}"
		local pat="${BACK}/bak-${digest}-*-${file}"

		if [ -f ${pat} ] ; then
			echo "backup for ${file} is current: $(ls ${pat})"
			continue
		fi

		cp -i ${file} ${bak}
		echo "backed up ${file} to ${bak}"
		touch ${file} 
	done
}

_backer_digest() {
	md5sum ${*} | sed 's, .*,,'
}

_backer_main ${*}
