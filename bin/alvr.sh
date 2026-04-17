#!/bin/bash	
	
_alvr_main() {
	${HOME}/funk/alvr_streamer_linux/bin/alvr_dashboard & 
}

_alvr_main ${*}
