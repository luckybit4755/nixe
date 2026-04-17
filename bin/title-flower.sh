#!/bin/bash	

_title_flower_main() {
	local width=${1-32}

	debug=""

	for ((i=0;i>-10;i++)) ; do 
		((direction=(${i}/${width})%2))
		((b4=${i} % ${width}))
		if [ 1 = ${direction} ] ; then
			((b4=${width}-${b4}))
		fi
	   	((l8=${width}-${b4}))

		delay=$(echo "(${b4} - ${width} / 2) / ${width}" | bc -l | cut -f2- -d-)
		delay=$(echo "(.1 + ${delay} * ${delay}) *.2" | bc -l )

		format="%${b4}s✿%${l8}s\n"
		flower=$(printf "\033]0;${format}\007" "" ""  | tr ' ' _ ) 
		if [ "" = "${debug}" ] ; then
			echo ${flower}
		else
			echo ${i} ${width} so ${b4} gives ${l8} and ${format} also ${direction}, delay ${delay}: ${flower}
		fi

		sleep ${delay}
	done
}

_title_flower_main ${*}
