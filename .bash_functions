#!/usr/bin/bash
cl () {
	\cd "$1"
	if [[ $? == 0 ]]; then
		gls -ph --color=always
	fi
}
#- - - - - - - - - - -
clp () {
	cl "$(pbpaste)"
}
#- - - - - - - - - - -
cdp () {
	local path="$(pbpaste)"
	if ! [[ -d "$path" ]]; then
		path=$(dirname "$path")
	fi
	\cd "$path"
}
#- - - - - - - - - - -
tml () {                   #too many lines
lines=$("$@" | wc -l)
if [ $lines -gt '100' ]; then
	precho "number of lines is $lines. Pipe into less? (y/n)"
	read
	if [ "$REPLY" == "y" -o "$REPLY" == "yes" ]; then
		"$@" | less
	fi
else
	"$@"
fi
}
#- - - - - - - - - - -
xdec () {
	# from base x to decimal
	# input - $1 base of input
	local base=$1
	shift
	while [ "$1" != "" ]; do
		echo -n "$(($base#$1))"
		if [ "$2" != "" ]; then
			echo -n ", "
		fi
		shift
	done
	printf '\n'
}
#- - - - - - - - - - -
decx () {
	# from decimal to base x
	# input - $1 base of output
	local base=$1
	shift
	while [ "$1" != "" ]; do
		echo "obase=$base;$1" | bc | tr -d \\n
		if [ "$2" != "" ]; then
			echo -n ", "
		fi
		shift
	done
	printf \\n
}
#- - - - - - - - - - -
bindec () {
	if [ $# == 0 ];then
		precho "usage: bindec 1101\n\
      finds 1101 in decimal"
		return
	fi
	xdec 2 "$@"
}
#- - - - - - - - - - -
hexdec () {
	if [ $# == 0 ];then
		precho "usage: hexdec ff\n\
      finds ff in decimal"
		return
	fi
	xdec 16 "$@"
}
#- - - - - - - - - - -
octdec () {
	if [ $# == 0 ];then
		precho "usage: octdec 040\n\
      finds 40 in decimal"
		return
	fi
	xdec 8 "$@"
}
#- - - - - - - - - - -
decbin () {
	if [ $# == 0 ]; then
		precho "usage: decbin 73\n\
      finds 73 in binary"
		return
	fi
	decx 2 "$@"
}
#- - - - - - - - - - -
decoct () {
	if [ $# == 0 ]; then
		precho "usage: decoct 20\n\
      finds 20 in octal"
		return
	fi
	decx 8 "$@"
}
#- - - - - - - - - - -
dechex () {
	if [ $# == 0 ]; then
		precho "usage: decoct 20\n\
      finds 20 in octal"
		return
	fi
	decx 16 "$@"
}
hexoct() {
	decoct $(hexdec "$@")
}
octhex() {
	dechex $(octdec "$@")
}
hexbin() {
	decbin $(hexdec "$@")
}
binhex() {
	dechex $(bindec "$@")
}
treeless () {
	case $# in
		0)
		tree . | less
		;;
		1)
		if [ -d "$1" ]; then
			tree $1 | less
		fi
		;;
		*)
		precho "treeless: too many arguments"
		precho "provide no args to treeless the current dir, or one arg to treeless"
		;;
	esac
	return
}
alias tree='treeless'
#- - - - - - - - - - -
unicode () {
	if [ "$#" == "0" ] || [ "$1" == '-h' ] || [ "$1" == '--help' ]; then
		precho "usage: unicode f0 9f 8c b8"
		precho "...echoes $(echo -e \\xf0\\x9f\\x8c\\xb8)"
		precho "Warning: beware of invisible/control chars"
		return
	fi

	local spaceNumberPair
	local args
	local e='s/([0-9][0-9])/\1 /gm'

	args="$@"
	if [[ "$args" =~ , ]]; then
		args=${args//,/ }
	fi

	echo -en '\e[1;97m'
	for arg in "$args"; do
		if [[ "$((${#arg} % 2))" == 0 ]] && [ "${#arg}" != 2 ]; then
			spaceNumberPair=$(gsed --regexp-extended --expression="$e" <<< $arg)
			for number in $spaceNumberPair; do
				echo -ne \\x${number}
			done
		else
			echo -ne \\x$arg
		fi
	done
	echo -e '\e[0m'
}
#- - - - - - - - - - -
hexdumb () {
	if [ $# == "0" ]; then
		precho "usage: hexdumb $(echo -ne \\U1f319)" #crescent moon unicode symbol
		precho "...dumps hex for the crescent moon"
		return
	fi
	local string="$(hexdump <<< $1)"
	#deletes sequences of numbers and 0a, in each line
	local e1="s/^[0-9]{7} |^[0-9]{7}| 0a[[:space:]]*$//g"
	#zaps empty lines
	local e2=/^$/d
	local hex=$(gsed --regexp-extended --expression="$e1" --expression="$e2" <<< $string)
	spaced-and-together $hex
}
#- - - - - - - - - - -
findname () {
	if [ $# == "0" ]; then
		precho 'run find here ./ case-insensitive and glob around args'
		return
	fi
	find -Hx . -iname "*$1*"
}
#- - - - - - - - - - -
findexec () {
	if [ $# == "0" ]; then
		precho 'gfind . -name "*$1*" -execdir $2 {} \;'
		return
	fi
	gfind . -name "*$1*" -execdir "$2" {} \;
}
#- - - - - - - - - - -
precho(){
	case "$1" in
		-k )
			shift
			# just a checkmark
			color --green --bold -- "✔ $@"
		;;
		-w )
			shift
			#\\040 - octal for space (0x20)
			color --yellow --bold -- "⚠️\040 $@"
		;;
		-e )
			shift
			color --red --bold -- "❌\040 $@"
		;;
		-h )
			shift
      printf "\e[1;36m♦︎ precho ➡ a shortcut to some common colors\n\
  only first short option is seen:\n\
  \e[1;32m-k\t OK. print in green. \t\t\$1 is not passed to color.\e[0m\n\
  \e[1;33m-w\t WARN. print in yellow. \t\$1 is not passed to color.\e[0m\n\
  \e[1;31m-e\t ERR. print in red. \t\t\$1 is not passed to color.\e[0m\n\
  \e[1;36m-*\t PRETTY. print in teal. \t\$1 is passed to color.\n\
  -h\t see this help\e[0m\n"
		;;
		*)
			echo -e "\e[1m♦︎ $@\e[0m"
		;;
	esac
}
#- - - - - - - - - - -
qmon () { #quick mount
if [ $# == "0" ];then
	args="EFI-MAC"
else
	args="$@"
fi
if [ "$1" == "-h" -o "$1" == "--help" ];then
	precho "Please give disk(s) and part(s) number(s) to mount."
	precho "Example: Disk4s1 -> 4 1 or Disk4s1 and Disk0s3 -> 4 1 0 3"
	precho "Arguments to qmon are grepped for in diskutil list, and last valid value is offered as default."
	return
fi
diskutil list | grep --ignore-case $args
if [ -f ~/.qmon-last ]; then
	file=~/.qmon-last
	while read last_value; do
		precho -n "Press return to defaults to "
		echo "$last_value"
		saved=$last_value
	done < "$file"
fi
read
if ! [ -z "$REPLY" ];then
	#the echo call allows the spliting on whitespace to work.
	qmon-parser $(echo $REPLY)
	return
fi
if ! [ -z "$saved" ];then
	qmon-parser $(echo $saved)
	return
fi
}
qmon-parser () {
	if [ $(($# % 2)) != 0 ];then
		precho -e "Error: Got a non even number of arguments"
		precho -e "$@"
		return
	fi
	while [ "$2" != "" ]; do
		disk="$1"
		part="$2"
		diskutil mount disk${disk}s${part}
		if [ $? == 0 ];then
			echo "$disk $part" > ~/.qmon-last
		fi
		shift
		shift
	done
	return
}
#- - - - - - - - - - -
runc () { #run n check
	bailout "runc is no longer"
}
#- - - - - - - - - - -
start-commands() {
	scheduler.sh --check
	if [ "$(pwd)" == "$HOME" ]; then
		\cd ~/Desktop
	fi
	return
}
#- - - - - - - - - - -
sritgo() {
	if [ "$1" == "-x" ];then
		shift
		source $HOME/.bashrc
		bug "$@"
	else
		source $HOME/.bashrc
		"$@"
	fi
}
#- - - - - - - - - - -
pbp () {
	echo "$(pbpaste)"
}
#- - - - - - - - - - -
color() {
	color.sh "$@"
}
#- - - - - - - - - - -
bailout() {
	local message=$@
	if [[ "$#" == "0" ]]; then
		message="error"
	fi
	echo -ne "\e[1;31m❌\040 $message\e[0m"
	if [[ ! "$-" =~ i ]]; then
		#shell is not interactive, so kill it.
		exit 1
	fi
}
#- - - - - - - - - - -
tra () {
	if [[ $# == 0 ]]; then
		return
	fi
	trash "$@"
	if [[ $? != 0 ]]; then
		return
	else
		\ls -Gph ./
	fi
}
#- - - - - - - - - - -
gr() { #grep recursive
	if [ "$#" == "0" -o "$1" == "-h" -o "$1" == "--help" ]; then
		precho "grep -l recursive, case-insensitive\n\
      ggrep -ri -E '\e[4;32margs\e[0m' -l"
		return
	fi
	# shopt -u nullglob #unset this shopt. It messes up regexes
	ggrep --color=auto -ri -E $@ -l
	# shopt -s nullglob #because it removes strings with *. Set it back.
}
#- - - - - - - - - - -
gl() { #grep -l simply
	if [ "$#" == "0" -o "$1" == "-h" -o "$1" == "--help" ]; then
		precho "grep -l case-insensitive, /$(basename $PWD)/\\052\n\
      ggrep --color=auto -iE '\e[4;32margs\e[0m' -l"
		return
	fi
	# shopt -u nullglob #unset this shopt. It messes up regexes
	ggrep --color=auto -iE "$@" -l *
	# shopt -s nullglob #because it removes strings with *. Set it back.
}
#- - - - - - - - - - -
gf() { #grep file
	if [ "$#" -lt 2 -o "$1" == "-h" -o "$1" == "--help" ]; then
		precho "grep case-insensitive\n\
      with 3 args: (pattern, context lines, file)\n\
      with 2 args: (pattern, file)"
		return
	fi
	# shopt -u nullglob
	if [[ "$#" == 3 ]]; then
		if [[ "$2" =~ - ]]; then
			dash=""
		else
			dash="-"
		fi
		ggrep --color=auto -i $dash"$2" -E "$1" "$3"
	else
		ggrep --color=auto -i -E "$1" "$2"
	fi
	# shopt -s nullglob
}
#- - - - - - - - - - -
spaceString() {
	bailout "function removed"
}
alias eatString='spaceString'
#- - - - - - - - - - -
bug() {
	set -x
	"$@"
	set +x
}
#- - - - - - - - - - -
center() {
	if [ $# == "0" -o "$1" == "-h" -o "$1" == "--help" ]; then
		echo center\(\) prints a message on the center of the screen
		center ~~ your message here ~~
		echo "--padding=N   push the message N chars right (positive) or left (negative)"
		return
	fi
	local padding=0
	local temp
	while [[ "${1:0:2}" == "--" ]]; do #while first arg begins with --
		case ${1%%=*} in
			"--padding")
			temp=${1##--*=}
			padding=$((padding + temp))
			;;
			*)
			echo "unkown opt ${1%%=*}"
			return
			;;
		esac
		shift
	done
	local message="$@"
	local message_length=${#message}
	let empty_space=$(tput cols)-$message_length #tput cols gives how many chars fit in a terminal line
	if [[ "$padding" -gt "$((empty_space / 2))" ]]; then		#
		padding=$((empty_space / 2))													#
	elif [[ "$padding" -lt "$((empty_space / -2))" ]]; then	# handles $padding being out of bounds
		padding=$((empty_space / -2))													#
	fi 																											#
	let pad_left=($empty_space/2)+$padding
	# echo $pad_left is left padding!
	let pad_right=($empty_space/2)-$padding
	# echo $pad_right is right padding!
	printf "%${pad_left}s%s%${pad_right}s" '' "$message" ''
	if [ "$((message_length % 2))" == 0 ]; then printf " "; fi #compensate for rounding down of odd nums
	printf "\n"
}
#- - - - - - - - - - -
spaced-and-together() {
	if [[ "$#" == 0 ]] || [[ "$1" == '-h' ]] || [[ "$1" == '--help' ]]; then
		echo "give numbers separated by spaces to receive them back spaced and together"
		return
	fi
	local spaced=''
	local together=''
	for n in "$@"; do
		spaced=$spaced' '$n
		together=$together$n
	done
	spaced='\e[1;97m'${spaced:1}'\e[0m'
	together='\e[1;97m'${together}'\e[0m'
	echo -e "  spaced: $spaced"
	echo -e "together: $together"
}
post-css() {
	if [[ "$1" == '-h' ]] || [[ "$1" == '--help' ]]; then
		precho "npx postcss css/*.css --use autoprefixer --dir ./build/css\
    \n -w,--watch:  npx postcss css/*.css --use autoprefixer --dir ./build/css --watch 2>/dev/null 1>&2 &"
		return
	fi
	if [[ $1 == '-w' ]] || [ "$1" == "--watch" ]; then
		npx postcss css/*.css --use autoprefixer --dir ./build/css --watch 2>/dev/null 1>&2 &
	else
		npx postcss css/*.css --use autoprefixer --dir ./build/css
	fi
}
do-sass() {
	if [[ "$1" == '-h' ]] || [[ "$1" == '--help' ]]; then
		precho "sass --watch css/:css/   2>/dev/null 1>&2 &\
    \n -v,--verbose:\tsass --watch css/:css/"
		return
	fi
	if [[ $1 == '-v' ]] || [ "$1" == "--verbose" ]; then
		sass --watch css/:css/
	else
		sass --watch css/:css/   2>/dev/null 1>&2 &
		export sassPID=$!
	fi
}
sed-rm-html-tags() {
	gsed -Ee 's/<[^>]+>|<\/[^>]+>//gm' || echo error. Please cat an html file into this function.
}
sed-rm-term-color-escapes() {
	gsed -Ee 's/\[[0-9][0-9]?m/ /gm' || echo error. Please cat terminal output into this function. TIP: caniuse-cli output
}
maybeDebug() {
	if [ "$x" ]; then
		bailout "use --debug not -x"
	fi
	if [ "$debug" ]; then
		local name=$(if [ "${FUNCNAME[1]}" == "main" ]; then printf "$0"; else printf "${FUNCNAME[1]}"; fi)
		printf "\n\e[4;33m$(printf %${COLUMNS}s) $(center DEBUGGING $name!)$(printf %${COLUMNS}s)\e[0m\n"
		set -x
	fi
}
tar7z () {
  if [ "$#" == 0 -o "$1" == "-h" ]; then
    precho "Provide a file. ./foo -> ./foo.tar.7z"
    bailout
  fi
  tar cf - "$1" 2>/dev/null | 7za a -si -mx=7 "$1.tar.7z" 1>/dev/null
}
parse-shorts() {
  while getopts ":abcdefghijklmnopqrstuvwxyz" opt; do
    case $opt in
      \?)
        # ignore invalid opts
      ;;
      *)
        allOptions+=$opt" "
        eval $opt="true"
      ;;
    esac
  done
}
debug(){
  if [[ "$x" ]]; then
    set -x
    echo -e "\e[1;33m\n\nDEBUGGING STARTED ON: $(if [ "${FUNCNAME[1]}" == "main" ]; then printf "$0"; else printf "${FUNCNAME[1]}"; fi)\n\n\e[0m"
  fi
}
rawgithub(){
	args="$@"
	args=${args/github/raw.githubusercontent}
	args=${args/\/raw\//\/}
	curl --silent $args
}