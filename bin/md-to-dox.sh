#!/bin/bash	

export NAME="Valerie Grafin von Mainberg"
export ADDRESS="388 Holbrook Rd"
export CITY="Newnan, GA, 30263"
export PHONE="[+1] (678) 636-9559"
export EMAIL="luckybit@duck.com"

export OUTPUT="${PWD}/generated"

# FIXME: this script assumes all the markdown files are in pwd
_md_to_dox_main() {
	if [ 0 = ${#} ] || [ "-h" = "${1}" ] ; then
		echo "usage: md-to-dox.sh <file.md> [file.md ...]"
		return 0
	fi

	mkdir -p ${OUTPUT}

	for file in ${*} ; do
		if [ -f ${file} ] ; then
			local name=$(echo ${file} | sed 's,\.md$,,')
			_md_to_dox_each ${name}
		else
			_md_to_dox_err "File not found: ${file}"
		fi
		#_md_to_dox_each vgvm_resume_brief
	done
}

_md_to_dox_each() {
	local name=${1}

	local title="${NAME}" # this was a bit obnoxious with the header...
	title="Resume"

	_md_to_dox_nfo "Creating documents based off ${name}.md"

	local md=${name}.md # FIXME: here is the assumption...
	local html=${OUTPUT}/${name}.html 
	local pdf=${OUTPUT}/${name}.pdf

	local css="${name}.css"
	if [ ! -f ${css} ] ; then
		local tmp=$(ls -tr *.css | tail -1)
		if [ "" = "${tmp}" ] ; then
			_md_to_dox_err "Could not find ${css} or any other css to use..."
			return 1
		fi
		_md_to_dox_warn "Could not find ${css}, using ${tmp}"
		css=${tmp}
	fi
	cp ${css} ${OUTPUT}

	if [ ${md} -nt ${html} ] || [ ${css} -nt ${html} ] ; then
		_md_to_dox_nfo "Creating html from markdown for ${name}"	

		egrep -v '^>>--' ${md} > .md

		pandoc \
			.md \
			-f markdown+smart \
			--css ${css} \
			--metadata pagetitle="${title}" \
			--to=html5 \
			-o ${html} \
			-s \
		|| return ${?}
		#--metadata title="${title}" \

		cat ${html} | sed 's,</body>,,;s,</html>,,' > .f.html

		if [ 0 = $(grep -c '>>--no-header' ${md}) ] ; then
			_header >> .f.html
		fi

		echo '</body></html>' >> .f.html
		mv .f.html ${html}
		_md_to_dox_nfo "Created html from markdown for ${name}"	

		ls ${html}
	else
		_md_to_dox_nfo "NOOP: HTML is newer than markdown for ${name}"
	fi

	if [ ${html} -nt ${pdf} ] ; then
		_md_to_dox_nfo "Creating pdf from html for ${name}"	
		./bin/html-to-pdf.js ${html} ${pdf} || return ${?}
		_md_to_dox_nfo "Created pdf from html for ${name}"	

		ls ${pdf}
		_md_to_dox_nfo xpdf ${name}.pdf 
	else 
		_md_to_dox_nfo "NOOP: PDF is newer than HTML for ${name}"
	fi
	_md_to_dox_nfo "Created documents based off ${name}.md"
	printf "%77s\n" "" | tr ' ' '-'
}

_header() {
cat << EOM
<div id="header">
	<div style="margin: auto;border-bottom:.1em solid black;color:black;font-weight:888;">
		<center>${NAME}</center>
	</div>
	<div>
		<span>${ADDRESS}</span>
		<span style="float:right">${PHONE}</span>
	</div>
	<div>
		<span>${CITY}</span>
		<span style="float:right">${EMAIL}</span>
	</div>
	<div style="float:right;margin-top:1em;margin-bottom:1em;">
		Page <span class="pageNumber"></span> of <span class="totalPages">
	</div>
</div>
EOM
}

_md_to_dox_nfo() {
	_md_to_dox_out INFO ${*}
}

_md_to_dox_warn() {
	_md_to_dox_out WARN ${*}
}

_md_to_dox_err() {
	_md_to_dox_out ERROR ${*}
}

_md_to_dox_out() {
	#local msg=$(echo ${*} | tr '[a-z]' '[A-Z]')
	local msg=${*}
	date +"%Y-%m-%d+%H-%M-%S ${msg}" 
}

_md_to_dox_main ${*}
