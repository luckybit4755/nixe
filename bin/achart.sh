#!/bin/bash	

# TODO: label the x-axis

_achart_main() {
	local cols=$( tput cols )
	local rows=$( tput lines )
	if [ "" = "${cols}" ] ; then cols=80; fi
	if [ "" = "${rows}" ] ; then cols=24; fi

	# _achart_cat |\
	awk -v cols=${cols} -v rows=${rows} '
		BEGIN {
			COUNT = 0;
		}

		{
			if ( 2 == NF ) {
				X[ COUNT ] = $1;
				Y[ COUNT ] = $2;
			} else {
				X[ COUNT ] = COUNT;
				Y[ COUNT ] = $1;
			}
			gsub( /[$,]/, "", Y[ COUNT ] );
			COUNT++;
		}

		END {
			lengthX = 1;
			lengthY = 1;
			UNSET = "unset"
			minX = maxX = minY = maxY = UNSET;
			for ( i = 0 ; i < COUNT ; i++ ) {
				x = X[i];
				y = Y[i];

				xl = length( x );
				yl = length( y );
				if ( xl > lengthX ) lengthX = xl;
				if ( yl > lengthY ) lengthY = yl;

				if ( UNSET == minX || x < minX ) minX = x;
				if ( UNSET == minY || y < minY ) minY = y;
				if ( UNSET == maxX || x > maxX ) maxX = x;
				if ( UNSET == maxY || y > maxY ) maxY = y;

				#print( X[i], Y[ i ], "->", xl, yl, "so", lengthX, lengthY );
			}

			diffX = maxX - minX;
			diffY = maxY - minY;

			#print( "x from", minX, "to", maxX, "is", diffX );
			#print( "y from", minY, "to", maxY, "is", diffY );

			k = .7;
			C = int( cols * k );
			R = int( rows * k );

			for ( i = 0 ; i < COUNT ; i++ ) {
				x = X[i];
				y = Y[i];

				p = xoff[ i ] = 4 + int( C * ( x - minX ) / diffX );
				q = yoff[ i ] = int( R - R * ( y - minY ) / diffY );
				labels[ q ] = y;
			}

			maxR = int( R * 1.2 );
			for ( r = 0 ; r < maxR ; r++ ) {
				rLast = r == maxR - 1;
				rNext = r == maxR - 2;
				if ( rLast ) break;
				

				label = labels[ r ];
				lc = "|";
				if ( rLast ) lc = "";
				if ( rNext ) lc = "+";
				
				printf( "%2d: %"lengthY"s %s", r, label, lc );

				s = "";
				for ( c = 0 ; c < C + 16 ; c++ ) {
					if ( rLast ) {
						# TODO: finish this...
						continue;
					}
					if ( rNext ) {
						s = s "-";
						continue;
					}

					found = 0
					for ( i = 0 ; i < COUNT ; i++ ) {
						if ( c == xoff[ i ] && r > yoff[ i ]) {
							found = 1;
							break;
						}
					}

					s = s ( found ? "#" : " " );
				}

				printf( "%s\n", s );
			}

			# the xlabels are pita..

			xlabelEnd = 4 + xoff[ COUNT - 1 ] + length( X[ count - 1 ] );
			for ( i = 0 ; i < xlabelEnd ; i++ ) {
				XL[ i ] = " ";
			}
			for ( i = 0 ; i < COUNT ; i++ ) {
				label = X[ i ];
				xo = xoff[ i ]- 1;

				for ( j = 1 ; j <= length( label ) ; j++ ) {
					XL[ j + xo ] = substr( label, j, 1 );
				}
			}

			s = ""
			for ( i = 0 ; i < xlabelEnd ; i++ ) {
				s = s XL[ i ];
			}

			printf( "%" lengthX + 7 "s %s \n", "", s );
		}
	'
}
_achart_cat() {
cat <<A
0   23,286  
200	26,672  
340	39,297  
350	36,579  
440	52,078  
A
return;
cat <<A
23,286
26,672
36,579
39,297
52,078
A
return
cat <<A
AMD Ryzen 7 3800X : 23,286 : 0
AMD Ryzen 7 5700X : 26,672 : $200
AMD Ryzen 7 7700X : 36,579 : $350
AMD Ryzen 9 5900X : 39,297 : $340
AMD Ryzen 9 7900X : 52,078 : $440
A
}

_achart_main ${*}
