#!/usr/bin/env bash

#========== Mac only
if [[ "$(uname -s)" =~ Darwin ]]; then
  export PATH="/bin:/usr/local/bin:/usr/bin:/sbin:/usr/local/sbin:/usr/sbin:/opt/X11/bin:$HOME/bin:/usr/local/opt/go/libexec/bin"
  export CDPATH=$HOME:/Volumes:$HOME/Desktop
  export EDITOR='/usr/local/bin/atom'
  export GOPATH="$HOME/.go"
  export LS_COLORS=$(cat $HOME/Code/LS_COLORS/LS_COLORS_RAW)
  tput init #sets COLUMNS env var that iterm2 doesnt, even tho terminal does

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
export BASH_ENV="$HOME/.bashrc"
shopt -s autocd cdspell dirspell globstar cmdhist lithist histverify histappend #nullglob

#========== Aliases
if [ -f ~/.bash_aliases ]; then source ~/.bash_aliases; fi

#========== Functions
if [ -f ~/.bash_functions ]; then source ~/.bash_functions; fi

#========== Software + Misc
if [ -f /usr/local/share/bash-completion/bash_completion ]; then source /usr/local/share/bash-completion/bash_completion; fi
