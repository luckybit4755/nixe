#!/bin/bash	
########################################################################
#
# This is a quick and easy way to plot some data files. Here's the deal:
#
# 1) create a working directory with the name for the graph
# 2) name your data files like "title1.txt", "title2.txt", etc
# 3) each line in each data file should be in the format: xvalue yvalue
# 4) run this script and it will create {name}.gnuplot and {name}.png
#
# @author Valerie Hammond
#
########################################################################

# gnuplot> plot "12.249.190.9" with linespoints smooth bezier, "128.177.70.65" with linespoints smooth bezier
_gnuplot_stuff_files() {
	if [ 0 = ${#} ] ; then 
		ls | egrep -v '\.(png|gnuplot|sh)'
	else 
		echo ${*}
	fi
}

_gnuplot_stuff_main() {
	local name=$( basename ${PWD} )
	_gnuplot_stuff_files ${*} \
	| awk -v name=${name} '
		BEGIN {
			p = "plot";

			#####
			# change settings here:
			print "set terminal png size 1024,512;"
			printf( "set output \"%s.png\";\n", name );
		}
		{
			title = $1;
			sub( /\.[a-z]*$/, "", title );
			#####
			# this is how each data file is plotted
			printf( "%s \"%s\" title \"%s\" with linespoints %s", p, $1, title, "," );
#printf( "%s \"%s\" title \"%s\" with linespoints smooth bezier %s", p, $1, title, "," );

			p = ""
		}	
		END { 
			print "";
		}
	' \
	| sed 's/,$/;/' \
	| tee ${name}.gnuplot \
	| gnuplot && ls ${PWD}/*.png
}

_gnuplot_stuff_main ${*}
