############################################################################
#
# echo ${vt_green}${bg_black}terminal coloring is neat${vt_none}
# 
# October 1st, 2008 
# val
#
############################################################################

export ESC=""

export vt_none="${ESC}[0m"
export vt_reset="${vt_none}"

export vt_bright="${ESC}[1m"
export vt_under="${ESC}[4m"
export vt_reverse="${ESC}[7m"
export vt_dim="${ESC}[2m"
export vt_blink="${ESC}[5m"
export vt_hidden="${ESC}[8m"

export vt_black="${ESC}[30m"
export vt_green="${ESC}[32m"
export vt_blue="${ESC}[34m"
export vt_cyan="${ESC}[36m"
export vt_red="${ESC}[31m"
export vt_yellow="${ESC}[33m"
export vt_magenta="${ESC}[35m"
export vt_white="${ESC}[37m"

export bg_black="${ESC}[40m"
export bg_green="${ESC}[42m"
export bg_blue="${ESC}[44m"
export bg_cyan="${ESC}[46m"
export bg_red="${ESC}[41m"
export bg_yellow="${ESC}[43m"
export bg_magenta="${ESC}[45m"
export bg_white="${ESC}[47m"
