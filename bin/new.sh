#!/bin/bash

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
			fs.readFile( args[ 0 ], 'utf-8', (e,d)=>{
				if ( e ) throw e;
				this.onFile( JSON.parse( d ) );
			});
		}

		onFile(contents) {
			console.log( JSON.stringify( contents, false, '\t' ) );
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
<HTML>
	<HEAD>
		<TITLE>$( basename ${*} | sed 's/\.html$//' )</TITLE>
		<script type="text/javascript">
			window.addEventListener('load', () => {} );
		</script>
		<style>
			body {
				font-family: sans-serif;
			}
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
