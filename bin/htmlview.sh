#!/bin/bash	

x_htmlview_main() {
	local directory=${HOME}/public_html/tmp/hv
	mkdir -p ${directory} || return 1
	local file=${directory}/hv-$( date +"%Y_%m_%d-%H_%M_%S" ).html
	file=${directory}/hv-tmp.html


	local url=$( echo ${file} | sed "s,^${HOME},http://localhost/~${USER}," )
	return


	ls ${*} | image_html.sh > ${file} \
	&& echo ok \
	&& open http://localhost/~${USER}//tmp/${USER}-hv.html
}

_htmlview_main() {
	ls ${*} | image_html.sh span > .hv.html && open .hv.html 
}

_htmlview_main ${*}
