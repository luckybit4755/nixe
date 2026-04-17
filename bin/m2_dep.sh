#!/bin/bash	

_m2_dep_main() {
	tr / ' ' |\
	sed 's,.* repository ,,;s,.* maven2 ,,' |\
	awk '
	{ 
		print "\t\t<dependency>";
		printf( "groupId " ); 
		for ( i = 1 ; i < NF - 2 ; i++ ) {
			printf( "%s%s", ( 1 == i ? "" : "." ), $i ); 
		}
		printf( "\n" ); 
		print "artifactId "$( NF - 2 ); 
		print "version "$( NF - 1 ); 
		print "\t\t</dependency>";
	} 
	' \
	| sed 's,^\(^[^ ]*\) \(.*\)$,###<\1>\2</\1>,' \
	| tr '#' '\t'


}

_m2_dep_main ${*}
