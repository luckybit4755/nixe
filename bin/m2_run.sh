#!/bin/bash	

_m2_run_main() {
	m2_cp.sh
	local classpath=$( cat m2_cp.txt ):.:${CP}
	echo java ${JAVA_ARGS} -classpath ... ${*}
	java ${JAVA_ARGS} -classpath ${classpath} ${*}
}

_m2_run_main ${*}
