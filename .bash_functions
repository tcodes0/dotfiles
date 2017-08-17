#! /bin/bash

cl () {
	\cd "$1"
	if [[ $? == 0 ]]; then
	    ls -Gph ./
	fi
}

#- - - - - - - - - - -

clp () {
	cl "$(pbpaste)"
}

#- - - - - - - - - - -

cdp () {
	\cd "$(pbpaste)"
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
	precho "...echoes $(unicode f0 9f 8c b8)"
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
    
    hexdump <<EOF
$1
EOF
    
}

#- - - - - - - - - - -

findname () {
    if [ $# == "0" ]; then
	precho 'find -Hx . -name "*$1*"'
	return
    fi
	
    find -Hx . -name "*$1*"
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
    if [ "$#" == "0" ];then
	echo -e "options: "
	echo -e "-c --critical 		critical text"
	echo -e "-d --no-delim 		to omit -> at the beginning"
	echo -e "-n 			to omit new line at the end"
	echo -e "Precho uses echo -e by default."
	return
    fi
    #font formatting
    #yellow fg, default bg
    format=$TMZLCOLOR
    #delimiter to use
    delim="-> "
    end="\e[0m"
    case "$1" in
	"--critical" | "-c")
	    #red fg, default bg, bold
	    format="\e[1;100;31m"
	    shift
	    ;;&
	"--no-delim" | "-d")
	    delim=""
	    shift
	    ;;&
    esac
    #shift logic and $1 not working. need to put it inside a loop to process args and use continue to resume iteration
    if [ "$1" == "-n" ]; then
	shift
	echo -en "$format$delim$@$end"
    else
	echo -e "$format$delim$@$end"
    fi
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
    start-on-desktop
    clear
    return
}
#- - - - - - - - - - -
sritgo() {
    if [ "$1" == "-x" ];then
	shift
	srit
	set -x
	"$@"
	set +x
    else
	srit
	"$@"
    fi
}
#- - - - - - - - - - -

