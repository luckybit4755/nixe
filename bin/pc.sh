#!/bin/bash	

_pc_main() {
#    awk -f ${HOME}/bin/columnbo.awk | sed 's, *$,,'

	awk '
BEGIN {
	row = 0
	max_fields = 0;
	super_max = 255;
} {
	for ( i = 1 ; i <= NF ; i++ ) {
		idx = row + super_max * i;
		len = length( $i );
		data[ idx ] = $i;
		if ( len > max[ i ] ) {
			max[ i ] = len;
		}
	}
	if ( NF > max_fields ) {
		max_fields= NF;
	}
	row++;
} END {
	for ( r = 0 ; r < row ; r++ ) {
		for ( i = 1 ; i <= max_fields ; i++ ) {
			idx = r + super_max * i;
			fmt = "%-" max[ i ]  "s ";
			printf( fmt , data[ idx ], max[ i ]  );
		}
		printf( "\n" );
	}
}' \
| sed 's, *$,,'
}

_pc_main ${*}
