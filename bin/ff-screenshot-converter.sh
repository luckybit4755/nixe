#!/bin/bash	

export EXPRESSION='\.(jpeg|jpg|png)$'

_connover_main() {
	local resolution=256
	local size=${resolution}x${resolution}

	local dir=${1-.}
	#cd ~/Downloads || return 1
	mkdir -p conno || return 2 

	cd ${dir} && ~/bin/spacey.sh 2>/dev/null && cd -

	ls ${dir}/*.* | egrep -i "${EXPRESSION}" | wc -l

	for f in $( ls ${dir}/*.* | egrep -i "${EXPRESSION}" ) ; do 
		local o=conno/$(md5sum ${f} | awk '{print $1}').jpg
		if [ -s ${o} ] ; then 
			continue;
		fi

		# pads...
		convert ${f} -border 0 -background white -resize "${size}" -gravity center -extent ${size} ${o}

		# force exact:
		#convert ${f} -resize "${size}!" ${o}

		if [ -s ${o} ] ; then
			ls -lh ${o}
		else
			echo "${o} is fckd"
			rm -f ${o}
		fi
	done

	ls conno | wc -l
	du -hs conno
}

_connover_main ${*}
