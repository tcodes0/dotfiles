#! /usr/bin/env bash
#- - - - - - - - - - -

cl() {
  # shellcheck disable=SC2164
  \cd -P "$1" 1>/dev/null
  iflast ls
}

#- - - - - - - - - - -

cdp() {
  local path && path="$(/usr/bin/pbpaste)"
  if [ ! -d "$path" ]; then
    path=$(/usr/bin/dirname "$path")
  fi
  # shellcheck disable=SC2164
  \cd "$path"
}

#- - - - - - - - - - -

cdc() {
  \pwd | tr -d '\n' | pbcopy
}

#- - - - - - - - - - -

xdec() {
  # from base x to decimal
  # input - $1 base of input
  echo conflicting with shfmt, disabled
  return
  local base=$1
  shift
  while [ "$1" != "" ]; do
    # echo -n "$(($base#$1))"
    if [ "$2" != "" ]; then
      echo -n ", "
    fi
    shift
  done
  printf '\n'
}

#- - - - - - - - - - -

decx() {
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

bindec() {
  if [ $# == 0 ]; then
    precho "usage: bindec 1101
    finds 1101 in decimal"
    return
  fi
  xdec 2 "$@"
}

#- - - - - - - - - - -

hexdec() {
  if [ $# == 0 ]; then
    precho "usage: hexdec ff
      finds ff in decimal"
    return
  fi
  xdec 16 "$@"
}

#- - - - - - - - - - -

octdec() {
  if [ $# == 0 ]; then
    precho "usage: octdec 04
      finds 40 in decimal"
    return
  fi
  xdec 8 "$@"
}

#- - - - - - - - - - -

decbin() {
  if [ $# == 0 ]; then
    precho "usage: decbin 7
      finds 73 in binary"
    return
  fi
  decx 2 "$@"
}

#- - - - - - - - - - -

decoct() {
  if [ $# == 0 ]; then
    precho "usage: decoct 2
      finds 20 in octal"
    return
  fi
  decx 8 "$@"
}

#- - - - - - - - - - -

dechex() {
  if [ $# == 0 ]; then
    precho "usage: decoct 20
      finds 20 in octal"
    return
  fi
  decx 16 "$@"
}
hexoct() {
  decoct "$(hexdec "$@")"
}
octhex() {
  dechex "$(octdec "$@")"
}
hexbin() {
  decbin "$(hexdec "$@")"
}
binhex() {
  dechex "$(bindec "$@")"
}

#- - - - - - - - - - -

unicode() {
  if [ "$#" == "0" ] || [ "$1" == '-h' ] || [ "$1" == '--help' ]; then
    precho "usage: unicode f0 9f 8c b8"
    precho "...echoes $(echo -e \\xf0\\x9f\\x8c\\xb8)"
    precho "Warning: beware of invisible/control chars"
    return
  fi

  local spaceNumberPair args e='s/([0-9][0-9])/\1 /gm'

  args="$*"
  if [[ "$args" =~ , ]]; then
    args=${args//,/ }
  fi

  echo -en '\e[1;97m'
  for arg in $args; do
    if [[ "$((${#arg} % 2))" == 0 ]] && [ "${#arg}" != 2 ]; then
      spaceNumberPair=$(gsed --regexp-extended --expression="$e" <<<"$arg")
      for number in $spaceNumberPair; do
        echo -ne \\x"${number}"
      done
    else
      echo -ne \\x"$arg"
    fi
  done
  echo -e '\e[0m'
}

#- - - - - - - - - - -

hexdumb() {
  if [ $# == "0" ]; then
    precho "usage: hexdumb $(echo -ne \\U1f319)" #crescent moon unicode symbol
    precho "...dumps hex for the crescent moon"
    return
  fi
  local string e1 e2 hex
  string="$(hexdump <<<"$1")"
  #deletes sequences of numbers and 0a, in each line
  e1="s/^[0-9]{7} |^[0-9]{7}| 0a[[:space:]]*$//g"
  #zaps empty lines
  e2=/^$/d
  hex=$(gsed --regexp-extended --expression="$e1" --expression="$e2" <<<"$string")
  spaced-and-together "$hex"
}

#- - - - - - - - - - -

findname() {
  if [ $# == "0" ]; then
    precho 'run find here ./ case-insensitive and glob around args'
    return
  fi
  # shellcheck disable=SC2185
  find -Hx . -iname "*$1*"
}

#- - - - - - - - - - -

findexec() {
  if [ $# == "0" ]; then
    precho "gfind . -name "*\$1*" -execdir $2 {} \\;"
    return
  fi
  gfind . -name "*$1*" -execdir "$2" {} \;
}

#- - - - - - - - - - -

precho() {
  case "$1" in
  -k)
    shift
    # just a checkmark
    color --green --bold -- "✔ $*"
    ;;
  -w)
    shift
    #\\040 - octal for space (0x20)
    color --yellow --bold -- "⚠️\\040 $*"
    ;;
  -e)
    shift
    color --red --bold -- "❌\\040 $*"
    ;;
  -h)
    shift
    # shellcheck disable=SC2154
    echo -en "${r256}♦︎ precho ➡ a shortcut to some common colors. Uses color.sh underneath.
      Only first short option is seen:
      \\e[1;32m-k\\t OK. print in green.                 \\$1 is not passed to color.\\e[0m
      \\e[1;33m-w\\t WARN. print in yellow.              \\$1 is not passed to color.\\e[0m
      \\e[1;31m-e\\t ERR. print in red.                  \\$1 is not passed to color.\\e[0m
      ${r256}-*\\t PRETTY. print in a random or teal.   \\$1 is passed to color.
      -h\\t see this help\\e[0m\\n"
    ;;
  *)
    if [ "$r256" ]; then
      echo -e "${r256}♦︎ $*\\e[0m"
    else
      echo -e "\\e[1m♦︎ $*\\e[0m"
    fi
    ;;
  esac
}

#- - - - - - - - - - -

start-commands() {
  scheduler.sh --check
  if [ "$(pwd)" == "$HOME" ]; then
    # shellcheck disable=SC2164
    \cd "$HOME/Code"
  fi
  return
}

#- - - - - - - - - - -

sritgo() {
  if [ "$1" == "-x" ]; then
    shift
    # shellcheck source=/Users/vamac/.bashrc.bash
    source "$HOME/.bashrc.bash"
    bug "$@"
  else
    # shellcheck source=/Users/vamac/.bashrc.bash
    source "$HOME/.bashrc.bash"
    "$@"
  fi
}

#- - - - - - - - - - -

color() {
  color.sh "$@"
}

#- - - - - - - - - - -

bailout() {
  local message=$*
  if [[ "$#" == "0" ]]; then
    message="error"
  fi
  echo -ne "\\e[1;31m❌\\040 $message\\e[0m"
  if [[ ! "$-" =~ i ]]; then
    #shell is not interactive, so kill it.
    exit 1
  fi
}

#- - - - - - - - - - -

tra() {
  [ $# == 0 ] && return 1

  local last

  for pathToTrash in "$@"; do
    trash "$pathToTrash" || return
    last="$pathToTrash"
  done

  [[ $last =~ (.+)[/][^/]+$ ]]
  # shellcheck disable=SC2035
  ternary -n "${BASH_REMATCH[1]}" ? ls "${BASH_REMATCH[1]}" : ls
}

#- - - - - - - - - - -

grepr() { #grep recursive
  if [ "$#" == "0" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    grepl -h
    precho "Also recursive. I.e. grep -r"
    return
  fi
  ggrep --color=auto -ri -E "$@" -l 2>/dev/null
}

#- - - - - - - - - - -

grepl() { #grep -l simply
  if [ "$#" == "0" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    precho "grep -l case-insensitive, extended regex, on \$PWD, no error messages."
    return
  fi
  ggrep --color=auto -iE "$@" -l ./* .* 2>/dev/null
}

#- - - - - - - - - - -

grepf() { #grep file
  if [ "$#" -lt 2 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    precho "grep case-insensitive
    with 3 args: (pattern, context lines, file)
    with 2 args: (pattern, file)"
    return
  fi
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
  local functionExitStatus=$?
  set +x
  return $functionExitStatus
}

#- - - - - - - - - - -

center() {
  if [ $# == "0" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo center\(\) prints a message on the center of the screen
    center ~~ your message here ~~
    echo "--padding=N   push the message N chars right (positive) or left (negative)"
    return
  fi
  local padding temp message message_length cols pad_left pad_right
  padding=0
  temp
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
  message="$*"
  message_length=${#message}
  cols=$(tput cols) # tput cols gives how many chars fit in a terminal line
  ((empty_space = cols - message_length))
  if [[ "$padding" -gt "$((empty_space / 2))" ]]; then
    padding=$((empty_space / 2))
  elif [[ "$padding" -lt "$((empty_space / -2))" ]]; then
    # handles $padding being out of bounds
    padding=$((empty_space / -2))
  fi
  pad_left=$(((empty_space / 2) + padding))
  # echo $pad_left is left padding!
  pad_right=$pad_right
  # echo $pad_right is right padding!
  printf "%${pad_left}s%s%${pad_right}s" '' "$message" ''
  if [ "$((message_length % 2))" == 0 ]; then printf " "; fi #compensate for rounding down of odd nums
  printf \\n
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

#- - - - - - - - - - -

sed-rm-html-tags() {
  gsed -Ee 's/<[^>]+>|<\/[^>]+>//gm' || echo error. Please cat an html file into this function.
}

#- - - - - - - - - - -

sed-rm-term-color-escapes() {
  gsed -Ee 's/\[[0-9][0-9]?m/ /gm' || echo error. Please cat terminal output into this function. TIP: caniuse-cli output
}

#- - - - - - - - - - -

tar7z() {
  if [ "$#" == 0 ] || [ "$1" == "-h" ]; then
    bailout "Provide a file. foo -> foo.tar.7z \\n"
    return 1
  fi
  local safeArg=$1
  if [[ "$safeArg" =~ [/]$ ]]; then
    safeArg=${safeArg:0:-1}
  fi
  tar cf - "$safeArg" 2>/dev/null | 7za a -si -mx=7 "${safeArg}.tar.7z" 1>/dev/null
}

#- - - - - - - - - - -

pipeTar7z() {
  tar cf - @- 2>/dev/null | 7za a -si -mx=7 "file.tar.7z" 1>/dev/null
}

#- - - - - - - - - - -

parse-shorts() {
  while getopts ":abcdefghijklmnopqrstuvwxyz" opt; do
    case $opt in
    \?)
      # ignore invalid opts
      ;;
    *)
      allOptions+=$opt" "
      eval "$opt=true"
      ;;
    esac
  done
}

#- - - - - - - - - - -

rawgithub() {
  if [ "$#" == 0 ]; then
    precho "Provide url to clone from GitHub. Output is stdout."
    return 1
  fi
  local args="$*"
  args=${args/github/raw.githubusercontent}
  args=${args/\/raw\//\/}
  curl --silent "$args"
}

#- - - - - - - - - - -

uni4() {
  [ "$#" == 0 ] || [ "$1" == -h ] && bailout "please provide a 4 char hex unicode value, e.g. e702 \\n" && return 1
  echo -ne \\u"$1"
}

#- - - - - - - - - - -

# part of git prompt!
_git_log_prettily() {
  [ "$1" ] && git log --pretty="$1"
}

#- - - - - - - - - - -

shwut() {
  [ ! "$1" ] && return
  Open "https://github.com/koalaman/shellcheck/wiki/SC$1"
}

#- - - - - - - - - - -

aliasg() {
  [ ! "$1" ] && return
  alias | grep "$@"
}

#- - - - - - - - - - -

#lazy git
lg() {
  local args="$*"

  if ! git add --all; then
    return 1
  fi

  if [ "$args" ]; then
    git commit -q -m "$args"
  else
    git commit -q -v
  fi
}
#- - - - - - - - - - -

#lazy commit
gcmsg() {
  local args="$*"

  if [ "$args" ]; then
    git commit -q -m "$args"
  else
    git commit -q -v
  fi
}

#- - - - - - - - - - -

#lazy git with push
lp() {
  lg "$@"
  iflast git push -q
}

#- - - - - - - - - - -

#git tag push
gtp() {
  git tag "$1"
  iflast git push -q origin "$1"
}

#- - - - - - - - - - -

#android emulator
emu() {
  if [ "$#" == 0 ]; then
    echo provide emulator name to run
    return
  fi
  eval "$HOME/Library/Android/sdk/emulator/emulator" "@$1"
}

adbm() {
  PATHS=(app/build/outputs/apk/release/app-release.apk android/app/build/outputs/apk/release/app-release.apk)
  DEST=$HOME/Desktop
  for path in "${PATHS[@]}"; do
    if [ -f "$path" ]; then
      mv "$path" "$DEST"
      echo moved to Desktop
      return
    fi
  done
}

# gradlew assemble release
gas() {
  if [ -d "./android" ]; then
    cd android || return
  fi
  ./gradlew assembleRelease
  cd ..
}

# gradlew clean
gac() {
  if [ -d "./android" ]; then
    cd android || return
  fi
  ./gradlew clean
  cd ..
}

goo() {
  local QQ && QQ=$(echo "$@" | tr ' ' '+')
  open "https://duckduckgo.com/?q=${QQ}&t=ffab&ia=web"
}

idea() {
  echo "$@" >>"$HOME/Desktop/ideas.txt"
}

sysbkp() {
  echo sudo rsync -a --exclude /Volumes --progress / /Volumes/TARGET
}

getver() {
  echo ios
  for plist in ios/*/Info.plist; do
    echo -e "\t $plist"
    grep --after-context=1 'BundleVersion</key>' <"$plist"
    echo
  done
  echo android
  grep --after-context=1 'versionCode ' <android/app/build.gradle
}

checkoutVersionFiles() {
  for file in android/app/build.gradle \
    ios/OneSignalNotificationServiceExtension/Info.plist \
    ios/SenseChat/Info.plist; do
    gco master -- $file
  done
}

gbg() {
  git branch | grep "$1"
}

ya() {
  yarn add "$1" --exact
}

yad() {
  yarn add -D "$1" --exact
}