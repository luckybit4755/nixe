#!/bin/bash	

_loop_mplayer_main() {
	mplayer -loop 0 -fixed-vo ${*}
}

_loop_mplayer_main ${*}
