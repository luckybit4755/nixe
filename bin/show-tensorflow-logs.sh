#!/bin/bash	

_show_tensorflow_logs_main() {
	local logs=${1-logs} ; shift
	if [ -d ${logs} ] ; then
		tensorboard --logdir ${logs} ${*} --bind_all
	else
		echo "no such directory: ${logs}"
		exit 1
	fi
}

_show_tensorflow_logs_main ${*}
