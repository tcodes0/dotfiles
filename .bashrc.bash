#!/usr/bin/env bash

#========== Most important helper for init files
dosource() {
  [ "$#" == 0 ] && return 1
  [ -f "$1" ] || return 1
  source "$1"
}

#it's recommended by a man page to set this here for better compatibility I guess
tput init

#========== Completions, external scripts, git prompt
GIT_PS1_SHOWDIRTYSTATE="true"
GIT_PS1_SHOWSTASHSTATE="true"
GIT_PS1_SHOWUNTRACKEDFILES="true"
GIT_PS1_SHOWUPSTREAM="auto"
# You can further control behaviour by setting GIT_PS1_SHOWUPSTREAM to a space-separated list of values: verbose name legacy git svn
# GIT_PS1_SHOWUPSTREAM="verbose name git"
GIT_PS1_STATESEPARATOR=""
# If you would like to see more information about the identity of commits checked out as a detached HEAD, set GIT_PS1_DESCRIBE_STYLE to one of these values: contains branch describe tag default
GIT_PS1_DESCRIBE_STYLE="branch"
# GIT_PS1_SHOWCOLORHINTS="true"

# Mac home dir
VHOME=/Users/vamac

#========== Early sourcing
dosource /usr/local/share/bash-completion/bash_completion
dosource $VHOME/.git-completion.bash
dosource $VHOME/.git-prompt.bash
dosource $VHOME/.yarn-completion.bash

#========== Mac only
if [[ "$(uname -s)" =~ Darwin ]]; then
  export PATH="/usr/local/bin:/bin:/usr/bin:/sbin:/usr/local/sbin:/usr/sbin:/opt/X11/bin:$VHOME/bin:/usr/local/opt/go/libexec/bin"
  export CDPATH=$VHOME:/Volumes:$VHOME/Desktop
  export EDITOR='code'
  export GOPATH="$VHOME/.go"
  export LS_COLORS=$(cat $VHOME/Code/LS_COLORS/LS_COLORS_RAW)

  if [ -f ~/.bash_ps1 ]; then
    source ~/.bash_ps1
  else
    export PS1="\n\w\n\$ "
  fi
fi

#========== Environment
export HISTSIZE=3000
export HISTFILESIZE=$HISTSIZE
export HISTTIMEFORMAT="%b %d "
export HISTCONTROL="ignoredups:erasedups"
export TIMEFORMAT=$'\n-time elapsed-\nreal\t%3Rs\nuser\t%3Us\nsystem\t%3Ss'
export BLOCKSIZE=1000000 #1 Megabyte
export LESS="--LINE-NUMBERS --prompt=?eEND:%pb\%. ?f%F:Stdin.\: page %d of %D, line %lb of %L"
export PAGER="/usr/bin/less --RAW-CONTROL-CHARS --HILITE-UNREAD --window=-5 --quiet +3uGg"
export BASH_ENV="$VHOME/.bashrc"
export GPG_TTY=$(tty)
shopt -s autocd cdspell dirspell globstar cmdhist lithist histverify histappend #nullglob

#========== Late sourcing
dosource ~/Code/functional-bash/main.bash
dosource ~/.bash_aliases
dosource ~/.bash_functions
dosource $VSCODE_OVERRIDES
