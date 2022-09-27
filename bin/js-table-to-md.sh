#!/bin/bash	

_js_table_to_md_main() {
	awk '
		function trim( s ) {
			v = "" s;
			sub( /^ */, "", v );
			sub( / *$/, "", v );

			len = length(v);
			f = substr(v,1,1);
			l = substr(v,len,1);
			if ( f == l && ( f == "\"" || f == "'"'"'" ) ) {
				v = substr(v,2,len-2);
			}

			return v;
		}

		function printMeARiver() {
			s = "";
			for ( i = 3 ; i < NF ; i++ ) {
				s = s " | " trim( $i );
				$i = ":-:";
			}
			s = trim( s " |" );
			print s;
		}

		BEGIN { FS = "│" }

		/^└─*[┴─]*┘$/ { 
			START = DATA = 0;
			print "";
		};

		DATA { printMeARiver() }
		START {
			START = 0;
			delete LABELS;
			printMeARiver();
			printMeARiver();
		}
		/^┌─*[┬─]*┐$/ { START = 1 }
		/^├─*[┼─]*┤$/ { DATA = 1  }
	'
}

_js_table_to_md_test() {
	echo 'console.table([
		{ "fat head" : .9, "stinky" : "yes, rather sadly" },
		{ "fat head" : .4, "stinky" : "yes, slightly" },
		{ "fat head" : .2, "stinky" : "no" },
		{ "fat head" : .7, "stinky" : "it'"'"'s ok" },
	])' | node 
}

_js_table_to_md_main ${*}
