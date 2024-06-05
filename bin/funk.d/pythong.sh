#!/bin/bash

pp() {
	local name=$(basename ${PWD} | sed 's/-/_/g' )
	echo name is ${name}
	local env=$( pyenv virtualenvs | sed 's,^*, ,' | awk -v NAME=${name} '$1 == NAME { print }' )
	if [ "" = "${env}" ] ; then
		echo "creating env: ${name} ${*}"
		pyenv virtualenv ${name} ${*} || return ${?}
	else
		echo "found env: ${env}"
	fi

	pyenv activate ${name} || return ${?}

	if [ -f requirements.txt ] && [ ! -f .i_made_pp ] ; then
		echo "installing requirements"
		python -m pip install --upgrade pip
		pip install -r requirements.txt || return ${?}
		touch .i_made_pp
	fi

	pyenv local ${name}

	echo "get 'er, ${name}"
}
