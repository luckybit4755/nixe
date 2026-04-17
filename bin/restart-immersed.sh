#!/bin/bash	
	
_restart_immersed_main() {
	echo -n "RU Sure [y/N]? "
	read k
	if [ "y" != "${k}" ] ; then
		echo ok
		return
	fi
	cd

	while true ; do
		local list=$(_restart_immersed_list)
		if [ "" = "${list}" ] ; then
			break
		fi

		echo "kiling: ${list}"
		for pid in ${list} ; do
			kill ${pid}
		done

		list=$(_restart_immersed_list)
		if [ "" = "${list}" ] ; then
			break
		fi
		echo "not dead yet: ${list}"
		sleep 3
	done

	if [ "${1}" = "bye" ] ; then
		echo not restarting
		return 
	fi

	echo "restarting..."
	nohup immersed.sh & 
	echo "restarted."
}

_restart_immersed_list() {
	ps -ef | grep -i immer | egrep -v '(grep|vim|restart-immersed)' | awk '{print $2}' 
}

_restart_immersed_main ${*}
