#!/bin/bash	

_jup_main() {
	#sudo pip install virtualenv
	#mkdir -p ${HOME}/funk/jupy ; cd ${_}
	#virtualenv jup_notebook

	cd ${HOME}/funk/jupy \
	&& jupyter notebook
}

_jup_main ${*}
