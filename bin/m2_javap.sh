#!/bin/bash	

_m2_find_jar_class_to_name() {
	sed 's,.class$,,;s,/,.,g'
}

_m2_find_jar_match_class() {
	local arg=${1} ; shift
	local jar
	for jar in ${*} ; do
		jar tf ${jar} | grep ${arg} | _m2_find_jar_class_to_name
	done | sort -u
}

_m2_find_jar_hunt() {
	local arg=${1} ; shift
	if [ "" = "${*}" ] ; then
		echo could not find ${arg}
	else 
		echo search for ${arg} in ${*}
		javap -classpath $( echo ${*} | tr ' ' ':' ) $( _m2_find_jar_match_class ${arg} ${*} )
	fi
}

_m2_find_jar_main() {
	if [ ! -f pom.xml ] ; then
		for arg in ${*} ; do
			balls=$( echo ${arg} | t | cut -f2 -d' ' | cut -f1 -d';' | xargs )
			if [ "" = "${balls}" ] ; then
				javap ${arg}
			else
				javap ${balls}
			fi 
		done
		return
	fi

	local m2_out="m2_cp.txt"
	local cp=$( cat m2_cp.txt ):./target/classes:./target/test-classes
	local javap="javap -classpath ${cp}"

	m2_cp.sh

	local arg
	for arg in ${*} ; do
		${javap} ${arg} 2>/dev/null
		if [ 0 != ${?} ] ; then 
			local a=$( echo ${arg} | t | cut -f2 -d' ' | cut -f1 -d';' | xargs ) 
			if [ "${a}" != "${arg}" ] ; then
				${javap} ${a}
			else
				echo ${arg} ???
			fi
		fi
	done
		
#	_m2_find_jar_hunt ${arg} $( grep -l ${arg} $( cat ${m2_out} | tr ':' ' ' ) 2> /dev/null )
}

_m2_find_jar_main ${*}
