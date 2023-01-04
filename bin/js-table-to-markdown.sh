#!/bin/bash	

_js_table_to_markdown_main() {
	_js_table_to_markdown_test |\
	awk '
		BEGIN { FS = "│" }
		/^[┌├└]/ { next }

		{
			sub( /[^│]*│/, "" );
			sub( /[^│]*│/, "| " );
			gsub( /│/, "|" );
			print
		}

		!DASHED {
			DASHED = 1;
			gsub( /[^|]/, "-" )
			print;
		}
	' \
	| tr "'" " "
}

_js_table_to_markdown_test() {
cat << XXX
┌─────────┬───────────┬───────────┬─────────────┬─────────────┐
│ (index) │ lol.peach │ xox.peach │ lol.yogurts │ xox.yogurts │
├─────────┼───────────┼───────────┼─────────────┼─────────────┤
│    0    │ '159,399' │ '159,381' │  '     59'  │  '     77'  │
│    1    │ '     13' │ '     13' │  '      0'  │  '      0'  │
│    2    │ '895,561' │ '895,455' │  '     86'  │  '    192'  │
└─────────┴───────────┴───────────┴─────────────┴─────────────┘
XXX
}

_js_table_to_markdown_main ${*}
