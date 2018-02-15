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
		precho "usage example: hexdec 1f "
		precho "returns 0x1f in decimal"
		return
	fi
	while [ "$1" != "" ]; do
		echo -n "$((0x$1))"
		if [ "$2" != "" ]; then
			echo -n ", "
		fi
		shift
	done
	echo ""
}
#- - - - - - - - - - -
dechex () {
	if [ $# == 0 ]; then
		precho "usage example: dechex 83"
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
	echo ""
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
	if [ $# -lt "4" ]; then
		precho "usage: unicode f0 9f 8c b8"
		precho "...echoes $(echo -e \\xf0\\x9f\\x8c\\xb8)"
		return
	fi
	if [ "$1" == "-n" ]; then
		shift
		echo -en \\x$1\\x$2\\x$3\\x$4
	else
		echo -e \\x$1\\x$2\\x$3\\x$4
	fi
}
#- - - - - - - - - - -
start-on-desktop () {
	if [ "$(pwd)" == "$HOME" ]; then
		\cd ~/Desktop
	fi
	return
}
#- - - - - - - - - - -
hexdumb () {
	if [ $# == "0" ]; then
		precho "usage: hexdumb $(echo -ne \\U1f319)" #crescent moon unicode symbol
		precho "...dumps hex for the crescent moon"
		return
	fi
	local string="$(hexdump <<-EOF
	$1
	EOF
	)"
	local e1="s/^[0-9]{7} |^[0-9]{7}| 0a[[:space:]]*$//g" #deletes sequences of numbers and 0a, in each line
	local e2=/^$/d #zaps empty lines
	local hex=$(gsed --regexp-extended --expression="$e1" --expression="$e2" <<-EOF
	$string
	EOF
	)
	echo -en '\e[1;49;97m'
	for number in $hex; do
		echo $number
	done
	echo -en '\e[0m'
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
precho () { #pretty echo
	# precho.sh $@
	center $@
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
	local i=30
	for x in $(echo h e l l o \!); do
		echo -en \\e[${i}m $x
		i=$((i+1))
	done
	echo -e \\e[0m
	echo "->>  Keep in mind bash doesn't use < > for comparisons~~"
	for x in $(echo b y e b y e \!); do
		echo -en \\e[${i}m $x
		i=$((i-1))
	done
	echo -e \\e[0m
	scheduler.sh --check
	start-on-desktop
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
echoform() {
	if [ "$1" == "-h" -o "$1" == "--help" ] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
		echo "usage: echoform 1 49 39 formatted text"
		echo -n "result: "; echoform 1 49 39 "formatted text"
		echo "the formatting is reset after each call, or use --clear/-c"
		return
	fi
	if [ "$1" == "-c" -o "$1" == "--clear" ]; then
		shift
		echo -ne '\e[0m'
		return
	fi
	local i=0
	while [[ "$1" =~ ^[0-9]+$ ]] && [ $i -lt 3 ]; do #regex to match numbers && 3 numbers max
		echo -ne "\e[$1m"
		shift
		i=$((i+1))
	done
	#echos all remaining arguments (words), and then formating is reset.
	echo -e "$@\e[0m"
}
#- - - - - - - - - - -
publish() {
	if ! [[ "$(dirname $PWD)" =~ ^/Users/vamac/Code ]]; then   # Don't run outside ~/Code
		echo "can't run publish outside $(echo ~/Code)"
		return
	fi
	rendercss
	echoform 1 49 32 "✔ Moving project files to ./public"
	\cp -R ./index.html ./public		#
	\cp -R ./js ./public						#
	\cp -R ./img ./public						#
	\cp -R ./node_modules ./public	#
	\cp -R ./*json ./public					# the backlash \ on \cp avoids any aliases called "cp"
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
		echo ggrep -ri -E 'args' -l
		echo gnu grep, recursive, case-insensitive, extended regex, files with matches
		return
	fi
	# shopt -u nullglob #unset this shopt. It messes up regexes
	ggrep --color=auto -ri -E $@ -l
	# shopt -s nullglob #because it removes strings with *. Set it back.
}
#- - - - - - - - - - -
gf() { #grep file
	if [ "$#" -lt 1 -o "$1" == "-h" -o "$1" == "--help" ]; then
    echo "with 3 args: (pattern, context lines, file)"
    echo "with 2 args: (pattern, file)"
		echo "gnu grep, case-insensitive, extended regex"
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
