#!/bin/bash	

_super_gnome_main() {
	export super="'Super_L'"
	export lame="'Alt_R'"

	local current=$( gsettings get org.gnome.mutter overlay-key )
	local next="${super}"

	if [ "${super}" = "${current}" ] ; then
		next=${lame}
	fi
	
	echo "super was: ${current}, setting it to ${next}"
	gsettings set org.gnome.mutter overlay-key ${next}
}

_super_gnome_main ${*}
