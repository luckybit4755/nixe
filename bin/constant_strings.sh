#!/bin/bash	

_constant_strings_main() {
	cat ${*} | gawk '
	function constant_string( value ) {
		name = value;
		name = gensub( /([a-z])([A-Z])/, "\\1_\\2", "g", value );
		name = toupper( substr( name, 2 ) );
		sub( "^[^a-zA-Z_0-9]*", "", name );
		sub( "[^a-zA-Z_0-9].*", "", name );
		if ( 0 == length( name ) ) {
			printf( "// %s\n", value );
		} else {
			printf( "public final static String %s = %s;\n", name, value );
		}
	}
	{
		len = length( $0 );
		started = -1;
		for ( i = 1 ; i <= len ; i++ ) {
			c = substr( $0, i, 1 );
			if ( "\\" == c ) {
				i++;
			} else {
				if ( "\"" == c ) {
					if ( -1 == started ) {
						started = i;
					} else {
						constant_string( substr( $0, started, i - started + 1 ) );
						started = -1;
					}
				}
			}
		}
	}'
}

_constant_strings_main ${*}
