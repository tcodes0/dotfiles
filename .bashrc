#!/usr/bin/env bash
#========== Environment
export PATH=/bin:/usr/local/bin:/usr/bin:/sbin:/usr/local/sbin:/usr/sbin:/opt/X11/bin:$HOME/bin
export HISTSIZE=3000
export HISTFILESIZE=$HISTSIZE
export CDPATH=/Users/vamac:/Volumes:/Users/vamac/Desktop
export HISTTIMEFORMAT="%b %d "
export HISTCONTROL="ignoredups:erasedups"
export TIMEFORMAT=$'\n-time elapsed-\nreal\t%3Rs\nuser\t%3Us\nsystem\t%3Ss'
export BLOCKSIZE=1000000 #1 Megabyte
export EDITOR='/usr/local/bin/atom'
export PAGER='/usr/bin/less'
export BASH_ENV="$HOME/.bashrc"
shopt -s autocd cdspell dirspell globstar cmdhist lithist histverify histappend #nullglob
#========== Aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
#========== Functions
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi
#========== Prompt
if [ -f ~/.bash_ps1 ]; then
  source ~/.bash_ps1
else
  export PS1="\W \e?"
fi
#========== Software + Misc
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    source /usr/local/share/bash-completion/bash_completion
fi
if [[ "$(which tabs)" ]]; then
  tabs 4 #tab size = 2 on MacOs/iTerm...
fi
