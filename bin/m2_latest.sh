#!/bin/bash	

M2_LATEST_MAVEN2_REPO="${HOME}/.m2/repository"

_m2_lastest_awker() {
	awk '
	function printer( artifact, version ) {
		print artifact"-"version".jar";
	}
	{
		artifact=$1;
		version=$2; 
		if ( artifact != last_artifact && last_artifact ) { 
			printer( last_artifact, the_version );
		} 
		the_version = version; 
		last_artifact = artifact; 
	} END { 
		printer( last_artifact, the_version );
	}'
}

_m2_latest_name_artifact_and_version() {
	rev | cut -f2,3 -d / | rev | tr / ' ' 
}

_m2_latest_name_finder() {
	local name=${1}
	find ${M2_LATEST_MAVEN2_REPO} -name "${name}*jar" |\
	sort -n |\
	_m2_latest_name_artifact_and_version
}

_m2_latest_name() {
	local name=${1}
	local jar
	for jar in $( _m2_latest_name_finder ${name} | _m2_lastest_awker ) ; do
		find ${M2_LATEST_MAVEN2_REPO} -name ${jar}
	done
}

_m2_latest_main() {
	local name
	for name in ${*} ; do
		_m2_latest_name ${name}
	done
}

_m2_latest_main ${*}
