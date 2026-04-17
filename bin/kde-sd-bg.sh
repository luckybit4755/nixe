#!/bin/bash	

export DEFAULT_PROMPT='Cyberpunk discotech full of dancing cyborgs and sleek vr netrunner chicks. An neon chipmunk dj is spinning mad tracks as the partiers twirl.'
export DEFAULT_PROMPT='An neon cyberpunk chipmunk dj is spinning mad tracks as the partiers twirl at the disco.'
#'Illustration from a golden age of comics showing a cool and provocative scene from "Weird Tales of The Strange"'
export DEFAULT_PROMPT='Comic book art from a vintage adventure story about spooky occult investigations into eldritch horror'

_kde_sd_bg_main() {
	local prompt=${1-${DEFAULT_PROMPT}}
	local filename=$(a111-image.js -p "${prompt}" -n 'nsfw, porn, bad art, extra limbs, missing limbs, weird anatomy, boring') 
	if [ 0 != ${?} ] ; then
		echo boo
		return
	fi

	echo "set bg to ${filename}"
	kde-bg.sh ${filename}
}

_kde_sd_bg_main ${*}
