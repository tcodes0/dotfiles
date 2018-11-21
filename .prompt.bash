#! /usr/bin/env bash
random256Color() {
  local c && c=$(echo -n $((RANDOM % 231)))
  # bad constrast colors, get another one
  if [ "$c" -le 17 ] || [ "$c" -ge 232 ]; then
    random256Color
  else
    echo -n "\\e[38;05;${c}m"
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
    mute command -v tput
    iflast export COLUMNS="$(tput cols | tr -d \\n)"
  fi
  echo -ne $COLUMNS
}

#get a random color, for use outside ps1, scripts (no i on $-) don't set this var
if [[ "$-" =~ i ]]; then
  r256=$(random256Color) && export r256
fi

# other formatting
end="\\[\\e[0m\\]"
underline="\\[\\e[4m\\]"
# bold="\\[\\e[1m\\]"
mainColor="\\[$r256\\]"
auxiliarColor="\\[$(random256Color)\\]"

makePS1() {
  # use "preGit" or "postGit" as arg 1 to integrate with gitprompt script

  # colors
  local purple pink clock spacer cols horizontalLine workdir # historia S green yellow light_black black
  purple="\\[\\e[34m\\]"
  pink="\\[\\e[35m\\]"
  # green="\\[\\e[32m\\]"
  # yellow="\\[\\e[33m\\]"
  # light_black="\\[\\e[90m\\]"
  # black="\\[\\e[30m\\]"
  #The spaces below avoids emoji collapsing on themselves. MacOS Sierra glitch.
  spacer='  '
  cols=$(getTermColumns)

  if [ "$(whoami)" != "root" ]; then
    case $((RANDOM % 7)) in
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
    # colorText=$pink
    decorations="💠 💠"$spacer
  fi

  horizontalLine="$auxiliarColor$underline$(printf %"${cols}"s)$end\\n"
  workdir="$mainColor\\w $end"
  # historia="$auxiliarColor!\! $end"
  # clock="$auxiliarColor\\@ $end"
  # S="$mainColor\\$ $end$colorText"

  case "$1" in
  "preGit") printf %s "${horizontalLine}${workdir}" ;;
  "postGit") printf %s "\\n${decorations}" ;;
  *) printf %s "${horizontalLine}${workdir}\\n${decorations}" ;;
  esac

  # printf "${horizontalLine}${clock}${workdir}\n${decorations}"
  # printf "${horizontalLine}${histoty}${workdir}${clock}\n${decorations}"
}
PS1=$(makePS1) && export PS1
# shellcheck disable=2089 disable=2090
PROMPT_COMMAND="__git_ps1 '$(makePS1 preGit)' '$(makePS1 postGit)' '$auxiliarColor$(glyphGitBranch)  $end$mainColor$underline%s$end'" && export PROMPT_COMMAND
