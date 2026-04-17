#!/bin/bash	
	
_complete_vim_moar_filter_main() {
	sed 's,[^a-zA-Z0-9_],\n,g' | egrep -i '[a-z]' | egrep -vi '^[a-z]{1,3}$'  | sort | uniq -c | sort -n | tail -1000 > ~/.vim/moar-complete.txt
}

_complete_vim_moar_filter_main ${*}
