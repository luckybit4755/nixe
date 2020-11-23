#!/bin/bash	

svg_bs='\
	<rect x="0" y="0" width="800" height="600" style="fill:#444444;stroke-width:0; stroke:rgb(0,0,0)" rx="16" ry="16"/> \
	HATERATION\
'

#<rect x="76" y="45" width="704" height="462" style="fill:rgb(0,0,0);stroke-width:1; stroke:rgb(0,0,0)"/> 

_bello_main() {
	local xlabel="seconds per query"
	local ylabel="number of responses"
	local title="Responses per Query Time" 

	if [ "" != "${TITLE}" ] ; then title=${TITLE} ; fi
	if [ "" != "${XLABEL}" ] ; then xlabel=${XLABEL} ; fi
	if [ "" != "${YLABEL}" ] ; then ylabel=${YLABEL} ; fi

cat << EOM | gnuplot
		set xlabel "${xlabel}"
		set ylabel "${ylabel}"
		set title "${title}" font "Helvetica,14" tc rgbcolor "#DDDDFF";

		set terminal svg size 800,600 fname 'Helvetica' fsize 10;
		set output '.fu.svg';
		set style data lines;

		set grid
		set key bmargin center horizontal;

		$( ls ${*} | awk '{ 
				l++;
				printf( "\t\tset style line %d  lw 4;\n", l ); 
				printf( "\t\tset style line 9%d lt 4 lw 4;\n", l ); 
			}' 
		)

		$( ls ${*} | sort -n | awk 'BEGIN { 
			printf( "plot " ); 
		} { 
			if ( 0 != q++ ) printf( ", " ); 
			printf( "\"%s\" lw 1.2 linetype %d, \"%s\" lw 3.5 linetype %d smooth bezier ", $1, q, $1, q ); 
		} END { 
			printf( ";\n" ); 
		}' )
EOM
	local fudge='<g style="fill:black; color:lightgray; stroke:currentColor; stroke-width:0.00; stroke-linecap:butt; stroke-linejoin:miter">'$(  grep path .fu.svg | grep -w Z | uniq  )'</g>'
	cat .fu.svg | sed "s@</defs>@</defs>${svg_bs}@;s@black@lightgray@;s@HATERATION@${fudge}@" > fu.svg
}

_bello_main ${*}
