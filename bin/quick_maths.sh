#!/bin/bash	

_quick_maths_main() {
	local field=${1-1}; shift
	local precision=${1-2}; shift

	awk -v field=${field} -v precision=${precision} '
		function begin() {
			printf "{";
		}
		function show( key, value ) {
			if ( F ) printf( ", " ); 
			printf( "\"%s\":%." precision "f", key, value );
			F = 33;
		}
		function end() {
			print "}";
		}
		{
			VALUES[ COUNT++ ] = $field;
		}
		END {

			print VALUES[ 0 ];
			begin();

			minimum = VALUES[ 0 ];
			maximum = VALUES[ 0 ];
			show( "count", COUNT );

			sum = 0;

			for ( i = 0 ; i < COUNT ; i++ ) {
				value = VALUES[ i ];
				sum += value;
				if ( value < minimum ) minimum = value;
				if ( value > maximum ) maximum = value;
			}

			show( "minimum", minimum );
			show( "maximum", maximum );
			show( "sum", sum );

			average = sum / COUNT;
			show( "average", average );

			if ( COUNT > 1 ) {
				variance = 0;
				for ( i = 0 ; i < COUNT ; i++ ) {
					value = VALUES[ i ];
					diff = average - value;
					variance += diff * diff;
				}
				stddev = sqrt( variance );
				#show( "variance", variance );
				show( "stddev", stddev );
			}

			end();
		}
	'
}

_quick_maths_main ${*}
