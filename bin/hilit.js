#!/usr/bin/env node 

class hilit {
	//green yellow blue red cyan magenta white
	static COLORS=[32,34,36,31,33,35,37];

	main( args ) {
		this.expressions = [];
		args.forEach( (arg,i) => {
			const x = (
				( arg[0] === arg[arg.length-1] ) 
				? arg.substr( 1, arg.length - 2 )
				: `\(${this.escapeRegex( arg )}\)`
			);
			const c = hilit.COLORS[ i % hilit.COLORS.length ];
			const expression = {
				x:new RegExp( x, 'gi' ),
				r:`\u001B[${c}m$1\u001B[0m`
			}
			this.expressions.push( expression );
		});

		require( 'readline' )
        .createInterface( { input:process.stdin, terminal:false } )
        .on( 'line', ( line ) => { this.onLine( line ) } )
	}

	onLine( line ) {
		this.expressions.forEach( expression => line = line.replace( expression.x, expression.r ) );
		console.log( line );
	}

	// https://stackoverflow.com/questions/3115150/how-to-escape-regular-expression-special-characters-using-javascript
	escapeRegex(text) {
  		return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
	}
};

new hilit().main( process.argv.slice( 2 ) );
