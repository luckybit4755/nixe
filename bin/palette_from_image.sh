#!/bin/bash	

_palette_from_image_main() {
	local htmp=${HOME}/tmp/pal-${USER}.html
	_palette_from_image_html ${*} > ${htmp}
	echo open ${htmp}
}

_palette_from_image_html() {
	local colors=$( _palette_from_image_colors ${*} | xargs )

cat << HHH
<!DOCTYPE html PUBLIC"-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
	<HEAD>
		<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
		<meta content="utf-8" http-equiv="encoding">
		<TITLE></TITLE>
		<script type="text/javascript">
			window.addEventListener('load', () => {
				const colors = '${colors}'.trim().split( ' ' );
				const n = colors.length;
				const s = Math.ceil( Math.sqrt( n ) );
				const p = ${PATCH-128};
				const w = s * p;

				const canvas = document.createElement( 'canvas' );
				const context = canvas.getContext( '2d' );
				document.body.appendChild( canvas );
				canvas.width = canvas.height = w;

				for ( let i = 0 ; i < n ; i++ ) {
					const x = p * ( i % s );
					const y = p * Math.floor( i / s );
					context.fillStyle = '#' + colors[i];
					context.fillRect( x, y, p, p );
				}
			} );
		</script>
	</HEAD>
	<BODY>
	</BODY>
</HTML>
HHH
}

_palette_from_image_colors() {
	local count=${COLORS-25}
	local tmp=/tmp/.palo.${USER}.txt
	convert ${1} -colors ${count} -unique-colors ${tmp}
	awk '
		/^[0-9]/ {
			color = $3;
			sub( /^#/, "", color );
			print substr( color, 1, 6 );
		}
	' ${tmp} 
	rm -f ${tmp}
	 
}

_palette_from_image_main ${*}
