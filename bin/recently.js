#!/home/vgvm/.nvm/versions/node/v17.5.0/bin/node

const fs = require( 'fs' );

class Recently {
	static HOME = process.env.HOME;
	static USER = process.env.USER;
	static VIM_LOG = `${Recently.HOME}/.vim_log.txt`;

	static SRC_DIR = `${Recently.HOME}/src/`;
	static SRC_HTTP = `http://localhost/~${Recently.USER}/src/`;

	static OUT = `${Recently.HOME}/public_html/recently.html`;

	constructor() {
	}

	main( args ) {
		const html = this.prefix();
		html.push( ...this.vimmed() );
		html.push( ...this.postfix() );

		fs.writeFileSync( Recently.OUT, html.join( '\n' ) );
	}

	vimmed( max = 22 ) {
		const entries = this.vimEntries( max );
		if ( !entries.length ) return;

		const html = new Array();
		html.push( '\t\t<h2>vim log</h2>' );
		html.push( '\t\t<ul>' );

		html.push(
			...entries.map( e => `\t\t\t<li><mono>${e.time} ${this.link( e.file )}</mono></li>` )
		)

		html.push( '\t\t</ul>' );

		return html;
	}

	vimEntries( max = 22 ) {
		const entries = new Array();

		for ( const line of fs.readFileSync( Recently.VIM_LOG ).toString().trim().split( '\n' ) ) {
			const fields = line.split( '\t' );
			let i = 0;
			const uuid = fields[ i++ ];
			const host = fields[ i++ ];
			const time = fields[ i++ ];
			const action = fields[ i++ ];
			if ( 'start' !== action ) continue;
			const files = (fields[ i++ ]||'').trim().replace( /\s+/g, ' ' ).split( ' ' );
			for ( const file of files ) {
				if ( !this.isJunkFile( file ) ) {
					entries.push( {host,time,file} );
				}
			}
		}

		entries.sort( (a,b) => b.time.localeCompare( a.time ) );

		const seen = new Set();
		return entries
			.filter( e => { const k = !seen.has( e.file ); seen.add( e.file ); return k } )
			.slice( 0, max )
	}

	isJunkFile( file ) {
		return !file.startsWith( Recently.SRC_DIR );
		return !file.startsWith( '/' ) || file.startsWith( '/tmp/bash' );
	}

	/////////////////////////////////////////////////////////////////////////////


	prefix() {
		return [
			`<!DOCTYPE html PUBLIC"-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">`,
			`<HTML xmlns="http://www.w3.org/1999/xhtml">`,
			`\t<HEAD>`,
			`\t\t<meta content="text/html;charset=utf-8" http-equiv="Content-Type">`,
			`\t\t<meta content="utf-8" http-equiv="encoding">`,
			``,
			`\t\t<TITLE>recently</TITLE>`,
			`\t\t<script type="text/javascript">`,
			`\t\t\twindow.addEventListener('load', () => {} );`,
			`\t\t</script>`,
			`\t\t<style>`,
			`\t\t\tbody { color:#ccb; background:black; font-family: sans-serif; margin:.5em; }`,
			`\t\t\tpre  { color:#8c8; }  `,
			`\t\t\ta    { color:#aad; text-decoration:none; }`,
			`\t\t</style>`,
			`\t</HEAD>`,
			`\t<BODY>`,
		];
	}

	postfix() {
		return [ '\t</BODY>', '</HTML>' ];
	}

	link( href, text, target ) {
		if ( href.startsWith( Recently.SRC_DIR ) ) {
			href = Recently.SRC_HTTP + href.substr( Recently.SRC_DIR.length );
		} else {
			return;
		}

		text = text ? text : href;
		target = target ? target : href;
		return `<A HREF="${href}" target="${target}">${text}</A>`;
	}
};

new Recently().main( process.argv.slice( 2 ) );
