#!/bin/bash	
	
_laighter_normal_maps_main() {
	if [ 0 != ${#} ] ; then
		for png in ${*} ; do
			_laighter_normal_maps_png ${png}
		done
		return 
	fi

	for png in $(ls *png | grep -v _n.png) ; do
		_laighter_normal_maps_main ${png}
	done
}

_laighter_normal_maps_png() {
	local png=${1} ; shift

	for op in n c o p ; do
		local laighted=$(echo ${png} | sed "s,\.png$,_${op}.png," )
		if [ ${png} -nt ${laighted} ] ; then
			echo run: laighter -d ${png} --no-gui -${op}
			laighter -d ${png} --no-gui -${op}
		fi
	done
}

_laighter_normal_maps_main ${*}
