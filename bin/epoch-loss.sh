#!/bin/bash	

_epoch_loss_main() {
	tr '' '\n' < ${1} |\
	awk -v COLUMNS=${COLUMNS-80} '

		function barring( percent, factor ) {
			if ( factor < 1 ) factor = 1;
			_bar = sprintf( "%" int( percent * factor ) "s", " " );
			while ( sub( / /, "#", _bar ) );
			return _bar;
		}

		BEGIN { 
			E = 0;
			LAST_AT = 0;
		}
		
		/^real/ { 
			minutes = int( $2 );

			LAST = MINUTES;
			MINUTES += minutes;

			over = E - LAST_AT;
			bump = minutes / over;
			b = int( bump )
			if ( bump - b > .5 ) b++;
			hour = minutes / 60;

			#printf( "since %6d: %3d = %7.2f at %3d over %3d epoch: %6.1f = %4d\n", LAST, minutes, hour, E, over, bump, b );

			for ( i = LAST_AT ; i < E ; i++ ) {
				o = i - LAST_AT + 1;
				AT[ i ] = LAST + ( i - LAST_AT + 1 ) * b;
				hour = AT[ i ] / 60;
				#printf( "%2d = %2d: %4d = %7.2f\n", i, o, AT[ i ], hour );
			}

			LAST_AT = E;
		}
		
		/^Epoch.*100%/ { 
			EPOCH = $2;
			EPOCHS++;
		}

		EPOCH && /loss=/ {
			loss = $0;
			sub( /.*loss=/, "", loss );
			sub( /,.*/, "", loss );

			elapsed = $0;
			sub( /.*\[/, "", elapsed );
			sub( /<.*/, "", elapsed );
			c = split( elapsed, timmy, /:/ );
			m = 1;
			seconds = 0;
			for ( i = c ; i>0 ; i-- ) {
				t = timmy[ i ];
				seconds += m * t;
				#printf( "> %d * %d = %d so %d\n", t, m, m * t, seconds );
				m *= 60;
			}
			#printf( "%s -> %d\n", elapsed, seconds );
			SECONDS_SUM += seconds;
			SECONDS_CNT++;

			percent = loss * 100;
				
			SAVE_INDEX[ E ] = EPOCH;
			SAVE_PERCENT[ E ] = percent;
			E++;

			if ( percent > MAX_PERCENT ) {
				MAX_PERCENT = percent;
				#printf( "max went from %f to %f cuz %s\n", q, MAX_PERCENT, $0 );
			}

			EPOCH = 0;
		}

		END {
			c = COLUMNS - 4 - 4 -5 -3;
			factor = int( c / MAX_PERCENT );

			printf( "%4s|%4s|%4s|%5s |%s\n", "off", "ndx", "hour", "%%", "bar" );
			for ( i = 0 ; i < E ; i++ ) {
				ndex = SAVE_INDEX[ i ];
				percent = SAVE_PERCENT[ i ];
				bar = barring( percent, factor )
				hour = AT[ i ] / 60;
				printf( "%4d|%4d|%4.1f|%5.2f%%|%s\n", i, ndex, hour, percent, bar );
			}

			if ( minutes ) {
				printf( "%d minutes = %.2f hours; %d minutes per epoch for %d epochs\n", MINUTES, MINUTES / 60, MINUTES / EPOCHS, EPOCHS ) 
			}
			if ( SECONDS_CNT ) {
				printf( "%d seconds / %d epochs is %.2f seconds per epoch\n", SECONDS_SUM, SECONDS_CNT, SECONDS_SUM / SECONDS_CNT );
			}

			printf( "c:%d, MAX_PERCENT:%f, factor=%d\n", c, MAX_PERCENT, factor );
		}
	'
}

_epoch_loss_main ${*}
