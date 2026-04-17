#!/bin/bash	

_m2_bean_me_get_setters() {
	m2_javap.sh ${*} \
	| awk '
		function dashing( value ) {
			nu = "";
				for ( j = 1 ; j <= length( value ) ; j++ ) {
					c = substr( value, j , 1 );
					up = toupper( c );
					if ( up == c && 1 != j ) {
						nu = nu "-";
					}
					nu = nu tolower( c )
				}
			return nu;
		}
		/public void set.*/ {
			name = $0;
			sub( /.* set/, "", name );
			sub( /\(.*/, "", name );
			camel = tolower( substr( name, 1, 1 ) ) "" substr( name, 2 );
			dashed = dashing( camel );
			if ( debug ) {
				print $0 " and " name " so " camel " and " dashed;
			} else {
				printf( "\t\t<property name=\"%s\" value=\"${%s}\"/>\n", camel, dashed );
			}
		}
	'
}

_m2_bean_me_class() {
	local class=${1}
	local name=$( echo ${class} | sed 's,.*\.,,' )
	name=$( echo ${name} | cut -c1 | tr '[A-Z]' '[a-z]' )$( echo ${name} | cut -c2- ) 

	printf '\t<bean id="%s" class=\"%s\">\n' ${name} ${class} 
	_m2_bean_me_get_setters ${class}
	printf "\t</bean>\n";

}

_m2_bean_me_main() {
	local arg
	for arg in ${*} ; do
		local class=$( echo ${arg} | t | sed 's,.* ,,;s,;,,' ) 
		if [ "" != "${class}" ] ; then
			_m2_bean_me_class ${class}
		fi
	done
}

_m2_bean_me_main ${*}
