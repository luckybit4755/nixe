#!/bin/bash	
# needs imagemagick and pandoc

_jp2s_to_epub_main() {
	local count=$( ls *.jp2 | awk 'END{print NR}' )
	if [ 0 = ${count} ] ; then
		echo "run this in a directory with .jp2 files..."
		return
	fi

	_jp2s_to_epub_convert

	echo "creating html"
	_jp2s_to_epub_html > j2e.html


	_jp2s_to_epub_txt > j2e.txt
	pandoc j2e.txt -o j2e.epub

	return

	echo "converting to epub"
	pandoc -f html -t epub3 -o j2e.epub j2e.html

	echo "done:"

	ls -lathr j2e.epub j2e.html
}

_jp2s_to_epub_txt() {
	basename "${PWD}" | sed 's,_jp2,,;s,^,% ,' 
	local c=1
	ls *jpg | head -3 | while read j ; do
		echo "# image ${c}"
		echo "![image #${c}](${j})"
		let c=${c}+1
	done
}

_jp2s_to_epub_convert() {
	local converted=0
	ls *.jp2 | while read f ; do
		local g=${f}.jpg
		if [ -f "${g}" ] ; then
			continue
		fi
		convert "${f}" "${g}"
		echo "converted to ${g}"
		let converted=${converted}+1
	done
	echo "converted ${converted} files"
}

_jp2s_to_epub_html() {
	_image_html_prefix
	ls *.jpg | awk '{
		f = $0;
		wrap = "div";
		printf( "\t\t\t<%s><a href=\"%s\"><img src=\"%s\"></img></a></%s>\n", wrap, f, f, wrap );
	}'
	_image_html_postfix
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

_jp2s_to_epub_main ${*}
