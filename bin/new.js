#!/usr/bin/env node 

const fs = require('node:fs').promises
const child_process = require('node:child_process')
const path = require('node:path')

const BIN_DIR = path.dirname(require.main.filename)
const TentacleTrove = require(`${BIN_DIR}/TentacleTrove`)

const CODE_PY = `#!/usr/bin/env python
#############################################################################

import argparse
import json
import logging

##
 #
 # Welcome to >CAMEL<
 #
 ##
class >CAMEL<:
    LOG = logging.getLogger(__name__)

    def __init__(self):
        self.parser = argparse.ArgumentParser(description="This is pythong")
        parser.add_argument("--port"   , type=int, default=51015)


    def main(self):
        self.args = self.args = parser.parse_args()
        >CAMEL<.LOG.info(f'settings: {json.dumps(vars(args))}')
    # end of main


# end of class >CAMEL<

if __name__ == "__main__":
    >CAMEL<().main()

# EOF
#############################################################################`

const CODE_JAVA = `/*not 2> /dev/null ; javac >CAMEL<.java && java >CAMEL< ; exit \${?} ; lol*/

public class >CAMEL< {
	public static void main( String[] arguments ) {
		System.out.println( "hi, >CAMEL<" );
	}
};`

const CODE_JS = `#!/usr/bin/env node 

const fs = require('node:fs').promises
const minimist = require("minimist")

class >CAMEL< {
	constructor() {
	}

	async main() {
		const args = minimist(process.argv.slice(2))
		for (const filename of args._) {
			const contents = await fs.readFile(filename, 'utf-8')
			const object = JSON.parse(contents)
			console.log(filename, JSON.stringify(object, null, '\\t'))
		}
	}
};

new >CAMEL<().main()`

const CODE_SH = `#!/bin/bash	
	
_>SNAKE<_main() {
	echo hi \${*}
}

_>SNAKE<_main \${*}`

const CODE_FRAG = `#ifdef GL_ES
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
}`

const CODE_HTML = `<!DOCTYPE html PUBLIC"-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
	<HEAD>
		<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
		<meta content="utf-8" http-equiv="encoding">

		<TITLE>>CAMEL<</TITLE>
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
</HTML>`

const CODE_GO = `package main

import( 
	"fmt"
	"time"
);

func main() {
	fmt.Printf( "it is %s\\n", time.Now().Format( "2006/01/02 15:04:05" ) );
}`

class NewCode {
    constructor() {
		this.extended = {
			py    : CODE_PY   ,
			java  : CODE_JAVA ,
			js    : CODE_JS   ,
			sh    : CODE_SH   ,
			frag  : CODE_FRAG ,
			go    : CODE_GO   ,
			html  : CODE_HTML ,
		}
		this.snakey = new Set('sh'.split(' '))
    }

    async main() {
		const args = process.argv.slice(2)
		const filish = args.join('_').replace(/\..*/, '').replace(/_*$/, '').replace(/.*\//, '')
		const camel = TentacleTrove.snakeToCamel(filish, true)
		const snake = TentacleTrove.camelToSnake(camel)
		const extension = args.filter(arg => arg.includes('.'))[0].replace(/.*\./, '').trim()
		if (!extension.length) {
			throw new Error(`could not find extension in ${args}`)
		}
		if (!(extension in this.extended)) {
			throw new Error(`unsupported extension ${extension}`)
		}

		const filename = (
			1 == args.length
			? args[0] // one name coming right up!
			: this.snakey.has(extension) ? `${snake}.${extension}` : `${camel}.${extension}`
		)
		console.log('filename is', filename)

		if (await TentacleTrove.fileExists(filename)) {
			console.log(filename, 'already exists')
		} else {
			console.log(args.length)
			console.log(args, '->', filish, 'and', camel, 'or', snake, 'of', extension)
			console.log(Object.keys(this.extended))
			const body = this.extended[extension].replace(/>CAMEL</g, camel).replace(/>SNAKE</g, snake)
			await fs.writeFile(filename, body)
			await fs.chmod(filename, parseInt('0755',8))
			console.log('wrote to', filename)
		}


		if (!await TentacleTrove.fileExists(filename)) {
			throw new Error(`${filename} not found`)
		}

		const editor = process.env.EDITOR || 'vim';
		const child = child_process.spawn(editor, [filename], { stdio: 'inherit' });
		child.on('exit',  (e, code) => console.log("finished editing", filename))
	}
};

new NewCode().main()
