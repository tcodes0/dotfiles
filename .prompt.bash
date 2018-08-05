#! /usr/bin/env bash
getNumber() {
  echo -n $((RANDOM % 231))
}

random256Color() {
  local c=$(getNumber)
  # bad constrast colors, get another one
  if [ "$c" -le 17 -o "$c" -ge 232 ]; then
    random256Color
  else
    echo -n "\e[38;05;${c}m"
  fi
}

glyphGitDev() {
  echo -ne \\uf7a1
}

glyphGitBranch() {
  echo -ne \\ue725
}

glyphGitCat() {
  echo -ne \\uf61a
}

getTermColumns() {
  if not truthy "$COLUMNS"; then
    mute which tput
    ifprevious export COLUMNS=$(tput cols | tr -d \n)
  fi
  echo -ne $COLUMNS
}

#get a random color, for use outside ps1, scripts (no i on $-) don't set this var
if [[ "$-" =~ i ]]; then
  export r256=$(random256Color)
fi

# other formatting
end="\[\e[0m\]"
underline="\[\e[4m\]"
bold="\[\e[1m\]"
mainColor="\[$r256\]"
auxiliarColor="\[$(random256Color)\]"

makePS1() {
  # use "preGit" or "postGit" as arg 1 to integrate with gitprompt script

  # colors
  local purple="\[\e[34m\]"
  local pink="\[\e[35m\]"
  local green="\[\e[32m\]"
  local yellow="\[\e[33m\]"
  local light_black="\[\e[90m\]"
  local black="\[\e[30m\]"
  #The spaces below avoids emoji collapsing on themselves. MacOS Sierra glitch.
  local spacer='  '
  local cols=$(getTermColumns)

  if [ "$(whoami)" != "root" ]; then
    case $(($RANDOM % 7)) in
    0) decorations="🐺 🌋"$spacer ;;
    1) decorations="🌸 🌿"$spacer ;;
    2) decorations="🚀 💫"$spacer ;;
    3) decorations="🍁 🍷"$spacer ;;
    4) decorations="🔮 🦋"$spacer ;;
    5) decorations="🌄 🎆"$spacer ;;
    6) decorations="🍇 🥓"$spacer ;;
    esac
  else
    mainColor=$purple
    auxiliarColor=$pink
    colorText=$pink
    decorations="💠 💠"$spacer
  fi

  local horizontalLine="$auxiliarColor$underline$(printf %${cols}s)$end\n"
  local workdir="$mainColor\w $end"
  local history="$auxiliarColor!\! $end"
  local clock="$auxiliarColor\@ $end"
  local S="$mainColor\\$ $end$colorText"

  case "$1" in
  "preGit") printf "${horizontalLine}${clock}${workdir}" ;;
  "postGit") printf "\n${decorations}" ;;
  *) printf "${horizontalLine}${clock}${workdir}\n${decorations}" ;;
  esac

  # printf "${horizontalLine}${clock}${workdir}\n${decorations}"
  # printf "${horizontalLine}${histoty}${workdir}${clock}\n${decorations}"
}
export PS1=$(makePS1)
export PROMPT_COMMAND="__git_ps1 '$(makePS1 preGit)' '$(makePS1 postGit)' '$auxiliarColor$(glyphGitBranch)  $end$mainColor$underline%s$end'"
