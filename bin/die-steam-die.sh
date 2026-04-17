#!/bin/bash	

export STEAMY="steam steamwebhelper steamtours steam.sh pressure-vessel-adverb"
	
_die-steam-die_main() {
	for s in ${STEAMY} ; do 
		echo killall ${s} 
		killall ${s} 
	done
	for s in ${STEAMY} ; do 
		echo killall -9 ${s} 
		killall -9 ${s} 
	done

	ps -ef | grep steam | egrep -v 'die-steam-die.sh|grep'


}

_die-steam-die_main ${*}
