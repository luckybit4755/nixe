#!/bin/bash	

_camel_time_main() {
	awk '
	function toCamel( value ) {
		nu = ""
		upped = 0;
		for ( j = 1 ; j <= length( value ) ; j++ ) {
			c = substr( value, j , 1 );
			if ( upped ) {
				if ( "_" == c ) {
					upped = 0;
				} else {
					nu = nu tolower( c );
				}
			} else {
				if ( "_" != c ) {
					nu = nu c;
					upped = 1;
				}
			}
		}
		return nu;
	}

	function toUnderscore( value ) {
		nu = ""
		for ( j = 1 ; j <= length( value ) ; j++ ) {
			c = substr( value, j , 1 );
			up = toupper( c );
			if ( up == c && 1 != j ) {
				nu = nu "_";
			}
			nu = nu up;
		}
		return nu;
	}
		
	function convert( value ) {
		if ( match( value, "^[A-Za-z][a-z0-9]+" ) ) {
			return toUnderscore( value );
		} else {
			if ( match( value, "^[A-Z0-9_]+$" ) ) {
				return toCamel( value );
			}
		}
		return value;
	} 
	{
		for ( i = 1 ; i <= NF ; i++ ) {
			printf( "%s\n", convert( $i ) );
		}
	}'
}

_camel_time_main ${*}
