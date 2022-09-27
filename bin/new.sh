#!/bin/bash

_new_py() {
	local file="${*}"
	local script=$( basename "${file}" | cut -f1 -d. | tr - _ )
cat << EOM | cut -f2- | sed 's,\t,    ,;s, *$,,' > $1
	#!/usr/bin/env python
	#############################################################################

	import argparse
	import os

	class ${script}:
		def __init__(self):
			self.parser = argparse.ArgumentParser(description="my cool script is cool")
			self.parser.add_argument("--log_directory", type=str, default="logs")

		def main(self):     
			args = self.parser.parse_args()


	if __name__ == "__main__":
		${script}().main()

	# EOF
	#############################################################################
EOM
}

_new_java() {
	local file="${*}"
	local script=$( basename "${file}" | cut -f1 -d. | tr - _ )
cat << EOM | cut -f2- > $1
	/*not 2> /dev/null ; javac ${script}.java && java ${script} ; exit ${?} ; lol*/
	public class ${script} {
		public static void main( String[] arguments ) {
			System.out.println( "hi, ${script}" );
		}
	};
EOM
}

_new_js_og() {
	local file="${*}"
	local script=$( basename "${file}" | cut -f1 -d. | tr - _ )
cat << EOM | cut -f2- > $1
	#!/usr/bin/env node 

	const fs = require( 'fs' );

	const ${script} = function() {
		const self = this;

		self.main = ( args ) => {
			fs.readFile( args[ 0 ], 'utf-8', (e,d)=>{
				if ( e ) throw e;
				let o = JSON.parse( d );
				console.log( JSON.stringify( o, false, '\t' ) );
			});
		};
	};

	new ${script}().main( process.argv.slice( 2 ) );
EOM
}

_new_js() {
	local file="${*}"
	local script=$( basename "${file}" | cut -f1 -d. | tr - _ )
cat << EOM | cut -f2- > $1
	#!/usr/bin/env node 

	const fs = require( 'fs' );

	class ${script} {
		constructor() {
		}

		main( args ) {
			return fs.readFile( args[ 0 ], 'utf-8', (e,d)=>{
				if ( e ) throw e;
				this.onFile( JSON.parse( d ) );
			});
			require( 'readline' )
				.createInterface( { input:process.stdin, terminal:false } )
				.on( 'line', ( line ) => this.onLine( line ) )
				.on( 'close', () => this.onClose() )
			;
		}

		onFile(contents) {
			console.log( JSON.stringify( contents, false, '\t' ) );
		}

		onLine( line ) {
			console.log( line );
		}
	
		onClose() {
		}
	};

	new ${script}().main( process.argv.slice( 2 ) );
EOM
}

_new_sh() {
	local file="${*}"
	local script=$( basename "${file}" | cut -f1 -d. | tr - _ )
cat << EOM | cut -f2- > $1
	#!/bin/bash	
	
	_${script}_main() {
		echo hi \${*}
	}

	_${script}_main \${*}
EOM
}

_new_frag() {
cat << EOM
#ifdef GL_ES
precision mediump float;
#endif

#define PI  3.141592653589793
#define PI2 6.283185307179586

uniform vec2 u_resolution;
uniform float u_time;

void main() {
	vec2 st = gl_FragCoord.xy/u_resolution.xy;
	vec3 color = vec3(0.0);

    gl_FragColor = vec4(color,1.0);
}
EOM
}

_new_html() {
cat << EOM
<!DOCTYPE html PUBLIC"-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
	<HEAD>
		<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
		<meta content="utf-8" http-equiv="encoding">

		<TITLE>$( basename ${*} | sed 's/\.html$//' )</TITLE>
		<script type="text/javascript">
			window.addEventListener('load', () => {} );
		</script>
		<style>
			body { color:#ccb; background:black; font-family: sans-serif; margin:.5em; }
			pre  { color:#8c8; }  
			a    { color:#aad; text-decoration:none; }
		</style>
	</HEAD>
	<BODY>
		<a href="javascript:( function() {
		} )();">bookmarklet</a>
	</BODY>
</HTML>
EOM
}

_new_go() {
cat << EOM
package main

import( 
	"fmt"
	"time"
);

func main() {
	fmt.Printf( "it is %s\\n", time.Now().Format( "2006/01/02 15:04:05" ) );
}
EOM
}

_new_usage() {
cat << EOM | cut -f2- > $1

	usage:  new newScript

EOM
}

_new_editor() {
	local editor=${EDITOR}
	if [ "" = "${editor}" ] ; then 
		editor=${VISUAL}
	fi
	if [ "" = "${editor}" ] ; then 
		editor=vim
	fi
	echo ${editor}
}

_new_create_if_needed() {
	local file="${*}"
	if [ ! -f ${file} ] ; then
		local ext=$( echo ${file} | sed 's,.*\.,,' )
		local type=${ext}
		if [ "mjs" = "${type}" ] ; then
			type="js"
		fi
		_new_${type} ${file} > ${file}
		if [ frag != "${ext}" ] && [ html != "${ext}" ] ; then 
			chmod 755 ${file}
		fi
	fi
}

_new_main() {
	local file="${*}"
	if [ "" = "${file}" ] ; then 
		_new_usage
	else
		file=$( echo ${file} | tr -d ' ' );
		_new_create_if_needed ${file}
		$( _new_editor ) ${file}
	fi
}

_new_main ${*}
