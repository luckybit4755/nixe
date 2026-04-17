#!/bin/bash	

_image_html_main() {
	local wrap=${1-div}

	if [ "kook" = "${wrap}" ] ; then
		_image_html_kook > i.html
		grep -c img i.html | sed 's,^,count:,' > /dev/stderr
	else
		_image_html_prefix
		_image_html_gen ${wrap}
		_image_html_postfix
	fi
}

_image_html_kook() {
	_image_html_prefix
	_image_html_extension span gif | grep -v '<h3>' | sort -rn
	_image_html_extension span png 
	_image_html_extension span jpg
	_image_html_postfix
}

_image_html_extension() {
	local wrap=${1} ; shift
	local extension=${1} ; shift
	find . -follow -size +5k -type f -name "*.${extension}" \
	| xargs ls -t \
	| _image_html_gen ${wrap} 
}
	
_image_html_gen() {
   local wrap=${1} ; shift

	awk -v wrap="${wrap}" '
		BEGIN {FS="/"}
  		{
			dir = $( NF -1 );
			if ( 2 < NF && dir != last ) printf("\t\t<h3>%s</h3>\n", dir);
			last = dir;
			f = $0;
			g = $0;
			#sub(/.*\//, "", g);
			printf( "\t\t\t<%s><a href=\"%s\"><img src=\"%s\"></img>%s</a></%s>\n", wrap, f, f, g, wrap );
		}
	'
}

_image_html_prefix() {
cat<<HTML
<!DOCTYPE html PUBLIC"-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
	<HEAD>
		<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
		<meta content="utf-8" http-equiv="encoding">

		<TITLE>images</TITLE>
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
HTML
}

_image_html_postfix() {
cat<<HTML
	</BODY>
</HTML>
HTML
}

_image_html_main ${*}
