#!/bin/bash	
	
_derp_main() {
	echo $(date) ${*} >> /tmp/derp.log
}

_derp_main ${*}
