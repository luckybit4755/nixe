#!/bin/bash

_gnome_bg_main() {
	local file=$( _fullpath ${1} )
	local mode=${MODE-scaled}
	if [ ! -f "${file}" ] ; then 
		echo "usage: gnome-bg.sh <image file>"
		echo "set MODE to one of: none wallpaper centered scaled stretched zoom spanned"
		echo "default MODE is scaled"
		return
	fi

	file="file://${file}"
	echo "using '${file}'"

	dconf write /org/gnome/desktop/background/picture-uri "'${file}'"
	dconf write /org/gnome/desktop/background/picture-uri-dark "'${file}'"
	dconf write /org/gnome/desktop/background/picture-options "'scaled'"
	dconf write /org/gnome/desktop/background/picture-options "'${mode}'"


	dconf dump /org/gnome/desktop/background/
}

_fullpath () { 
	cd $( dirname ${1} ) 2> /dev/null \
	&& echo ${PWD}/$( basename ${1} ) 
}

_gnome_bg_main ${*}
