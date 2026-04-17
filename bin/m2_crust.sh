#!/bin/bash	

_m2_crust_dep() {
	local jar=${1}
	local base=$( basename ${jar} | sed 's,.jar$,,' )
	local artifactId=$( echo ${base} | sed 's,-[0-9].*,,' )
	local version=$( echo ${base} | sed "s,^${artifactId}-*,," )
	if [ "" = "${version}" ] ; then
		version="unknown"
	fi
cat << EOM
	<dependency>
		<artifactId>${artifactId}</artifactId>
		<groupId>unknown</groupId>
		<version>${version}</version>
		<scope>system</scope>
		<systemPath>\${basedir}/${jar}</systemPath>
	</dependency>
EOM
}

_m2_crust_main() {
	for jar in $( find ${*} -name "*.jar" ) ; do
		_m2_crust_dep ${jar}
	done
}

_m2_crust_main ${*}
