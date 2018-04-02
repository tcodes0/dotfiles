#!/usr/bin/bash
cl () {
	\cd "$1"
	if [[ $? == 0 ]]; then
		\ls -Gph ./
	fi
}
#- - - - - - - - - - -
clp () {
	cl "$(pbpaste)"
}
#- - - - - - - - - - -
cdp () {
	local path="$(pbpaste)"
	if ! [[ -d $path ]]; then
		path=$(dirname $path)
	fi
	\cd $path
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
hexdec () {
	if [ $# == 0 ];then
		precho "usage: hexdec 1f "
		precho "finds 0x1f in decimal"
		return
	fi
	while [ "$1" != "" ]; do
		echo -n "$((0x$1))"
		if [ "$2" != "" ]; then
			echo -n ", "
		fi
		shift
	done
	printf '\n'
}
#- - - - - - - - - - -
dechex () {
	if [ $# == 0 ]; then
		precho "usage: dechex 83"
		precho "finds 83 in hex"
		return
	fi
	while [ "$1" != "" ]; do
		printf '%x' $1
		if [ "$2" != "" ]; then
			echo -n ", "
		fi
		shift
	done
	printf '\n'
}
#- - - - - - - - - - -
bindec () {
	if [ $# == 0 ];then
		precho "usage: bindec 1101 "
		precho "finds 1101 in decimal"
		return
	fi
	while [ "$1" != "" ]; do
		echo -n "$((2#$1))"
		if [ "$2" != "" ]; then
			echo -n ", "
		fi
		shift
	done
	printf '\n'
}
#- - - - - - - - - - -
decbin () {
	if [ $# == 0 ]; then
		precho "usage: decbin 73"
		precho "finds 73 in binary"
		return
	fi
	while [ "$1" != "" ]; do
		echo "obase=2;$1" | bc
		if [ "$2" != "" ]; then
			echo -n ", "
		fi
		shift
	done
}
#- - - - - - - - - - -
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
	echo -en '\e[1;97m'
	local spaceNumberPair=''
	local e='s/([0-9][0-9])/\1 /gm'
	for arg in "$@"; do
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
	case "$@" in
		-k* | *--ok*)
			color --green --bold "✔ " $@
		;;
		-w* | *--warning*)
			color --yellow --bold "⚠️  " $@
		;;
		-e* | *--err* | *--error*)
			color --red --bold "❌  " $@
		;;
		*)
			color --teal --bold "♦︎ " $@
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
		precho -c "Error: Got a non even number of arguments"
		precho -c "$@"
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
if  [ "$#" == 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	precho "Runc runs a command and checks its exit status"
	precho "Use -c to cause an exit 1 on error"
	precho "Warning: -c, if not running from a script, will exit your shell"
	return
fi
if [ "$1" == "-c" ]; then
	critical="true"
	shift
fi
"$@"
if [ "$?" != 0 ];then
	if [ "$critical" == "true" ]; then
		precho -c "Aborting on critical error: $@"
		exit 1
	fi
	precho -c "Error: $@"
	return
fi
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
	color --bold --red "❌  $message"
	if [[ ! "$-" =~ i ]]; then
		#shell is not interactive, so kill it.
		exit 1
	fi
}
#- - - - - - - - - - -
publish-rsync(){
	if [[ "$@" =~ -h ]]; then
		precho "uploads ./public via ssh to web server"
		precho "-y\t auto confirm"
		precho "-v\t verbose rsync"
		precho "-h\t see this help"
		return
	elif [[ "$@" =~ -y ]]; then
		REPLY="yes"
	else
		color --bold --purple "♦︎ Upload to server via rsync? (y/n)"
		echo -e "\e[1;49;34m...defaulting to yes in 6s\e[0m"
		read -t 6
		if [ "$?" != 0 ]; then
			REPLY=''
		fi
	fi
	if [ "$REPLY" == "y" ] || [ "$REPLY" == "yes" ] || [ "$REPLY" == "Y" ] || [ "$REPLY" == "YES" ] || [ "$REPLY" == "" ]; then
		echo -ne "\e[1;49;33m♦︎ Uploading all files with rsync...\e[0m"
		local options="--recursive --update --inplace --no-relative --checksum --compress"
		if [[ "$@" =~ -v ]]; then
			options=$options" -v"
		fi
		local SSH="ssh -p 21098"
		local host="tazemuad@server179.web-hosting.com:/home/tazemuad"
		local remote_dir=$host/sites/$(basename $PWD)/
		local local_dir=$PWD/public/
		rsync $options -e "$SSH" $local_dir $remote_dir
		if [[ "$?" == 0 ]]; then
			echo -e "\r\e[1;49;32m✔ Done $(date +%H:%M)                                         \e[0m"
		fi
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
		echo gnu grep, recursive, case-insensitive, extended regex, files with matches
		echo -e ggrep -ri -E '\e[4;32margs\e[0m' -l
		return
	fi
	# shopt -u nullglob #unset this shopt. It messes up regexes
	ggrep --color=auto -ri -E $@ -l
	# shopt -s nullglob #because it removes strings with *. Set it back.
}
#- - - - - - - - - - -
gf() { #grep file
	if [ "$#" -lt 1 -o "$1" == "-h" -o "$1" == "--help" ]; then
		echo "gnu grep, case-insensitive, extended regex"
    echo "with 3 args: (pattern, context lines, file)"
    echo "with 2 args: (pattern, file)"
		return
	fi
	shopt -u nullglob
	if [[ "$#" == 3 ]]; then
		ggrep --color=auto -i -"$2" -E "$1" "$3"
	else
		ggrep --color=auto -i -E "$1" "$2"
	fi
	shopt -s nullglob
}
#- - - - - - - - - - -
spaceString() {
	local string=$@ #all arguments
	local length=${#string}
	local index=0
	while [[ $index -lt $length ]]; do
		echo -n ${string:index:1}" " #give us a substring with length 1 starting at index $index
		index=$((index+1))
	done
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
		precho 'npx postcss css/*.css --use autoprefixer --dir ./public/css'
		precho '-w,--watch:\tnpx postcss css/*.css --use autoprefixer --dir ./public/css --watch 2>/dev/null 1>&2 &'
		return
	fi
	if [[ $1 == '-w' ]] || [ "$1" == "--watch" ]; then
		npx postcss css/*.css --use autoprefixer --dir ./public/css --watch 2>/dev/null 1>&2 &
	else
		npx postcss css/*.css --use autoprefixer --dir ./public/css
	fi
}
do-sass() {
	if [[ "$1" == '-h' ]] || [[ "$1" == '--help' ]]; then
		precho 'sass --watch css/:css/   2>/dev/null 1>&2 &'
		precho '-v,--verbose:\tsass --watch css/:css/'
		return
	fi
	if [[ $1 == '-v' ]] || [ "$1" == "--verbose" ]; then
		sass --watch css/:css/
	else
		sass --watch css/:css/   2>/dev/null 1>&2 &
	fi
}
sed-rm-html-tags() {
	gsed -Ee 's/<[^>]+>|<\/[^>]+>//gm' || echo error. Please cat an html file into this function.
}
sed-rm-term-color-escapes() {
	gsed -Ee 's/\[[0-9][0-9]?m/ /gm' || echo error. Please cat terminal output into this function. TIP: caniuse-cli output
}
