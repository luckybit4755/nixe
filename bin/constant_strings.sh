#!/bin/bash	

_constant_strings_main() {
	cat ${*} | gawk '
	function constant_string( value ) {
		first = substr(value,2,1);
		if ( first ~ /[0-9$.\\]/ ) return; # avoid junk
		if ( value ~ /[ \t]/ ) return; # no multi-word constants... good idea or bad idea?

		name = value;
		name = gensub( /([a-z])([A-Z])/, "\\1_\\2", "g", value );
		name = toupper( substr( name, 2 ) );
		
		gsub( "-", "_", name );
		sub( "^[^a-zA-Z_0-9]*", "", name );
		sub( "[^a-zA-Z_0-9].*", "", name );
		if ( 2 >= length( name ) ) {
			printf( "// %s\n", value );
		} else {
			printf( "public final static String %s = %s;\n", name, value, first );
		}
	}

	/\/\*/ { COMMENT = 1 }

	!COMMENT {
		clean = $0;
		sub( /\/\/.*/, "", clean );

		# very hacky
		gsub( /'"'"'/, "\"", clean );
		gsub( /`/, "\"", clean );

		len = length( clean );
		started = -1;
		for ( i = 1 ; i <= len ; i++ ) {
			c = substr( clean, i, 1 );
			if ( "\\" == c ) {
				i++;
			} else {
				if ( "\"" == c ) {
					if ( -1 == started ) {
						started = i;
					} else {
						constant_string( substr( clean, started, i - started + 1 ) );
						started = -1;
					}
				}
			}
		}
	

	}

	/\*\// { COMMENT = 0 }
	' | sort -u
}

_constant_strings_main ${*}
