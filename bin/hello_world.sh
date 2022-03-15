#!/bin/bash	
############################################################################
#
# Oh, you love landing on a new unplowed machine!
#
############################################################################

_hello_world_main() {
	local expert=$( cd $( dirname $( which ${0} ) ) ; pwd )

	cd ${HOME}

	local girl_makes_good
	for girl_makes_good in profile .vim .vimrc ; do
		local watering_hole=$( echo ${girl_makes_good} | sed 's,^\([^.]\),.\1,' )
		girl_makes_good=${expert}/${girl_makes_good}

		ls -d ${watering_hole} 2>/dev/null >/dev/null 
		if [ 0 = ${?} ] ; then
			echo 'woops! you already have a' ${watering_hole} 'moving on...'
			continue
		fi


		local sheriff
		local yocal=1

		for sheriff in f d ; do 
			if [ -${sheriff} ${girl_makes_good} ] && [ -${sheriff} ${watering_hole} ] ; then
				yocal=0
				break
			fi
		done

		if [ 0 = ${yocal} ] ; then
			echo 'ayup! you already have a' ${watering_hole} 'moving on...'
			continue
		fi

		echo "I will hookup ${girl_makes_good} to ${HOME}/${watering_hole}"
		ln -s ${girl_makes_good} ${watering_hole}
	done

	# hurray for special cases!
	if [ -f ${HOME}/.bash_profile ] ; then
		diff -q .bash_profile .profile >/dev/null 2>/dev/null
		if [ 0 = ${?} ] ; then
			echo ".bash_profile and .profile are already entangled..."
		else 
			local target=${HOME}/.bash_profile.old.${$}
			echo there is a ${HOME}/.bash_profile file... moving it to ${target}
			mv -i .bash_profile ${target}
			ln -s .profile .bash_profile
		fi
	else
		echo "hookup .profile to .bash_profile"
		echo ln -s .profile .bash_profile
	fi
}

_hello_world_main ${*}

############################################################################
# did you think this script would just go on forever?
############################################################################
