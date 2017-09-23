#========== Environment
export PATH=$PATH:/usr/local/sbin:/Users/vamac/bin
export HISTSIZE=3000
export HISTFILESIZE=$HISTSIZE
export CDPATH=/Users/vamac:/Volumes:/Users/vamac/Desktop                     
export HISTTIMEFORMAT="%b %d "
export HISTCONTROL="ignoredups:erasedups"
export TIMEFORMAT=$'\n-time elapsed-\nreal\t%3Rs\nuser\t%3Us\nsystem\t%3Ss'
export BLOCKSIZE=1000000
export EDITOR='/usr/bin/emacs'
export PAGER='/usr/bin/less'
shopt -s autocd cdspell dirspell globstar cmdhist lithist histverify histappend nullglob
set -o noclobber
#-- my vars
export webcommit='4506e56'
#========== Functions
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi
#========== Aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
#========== Prompt
if [ -f ~/.bash_ps1 ]; then
    source ~/.bash_ps1
fi
#========== [<0;54;29mq]Misc
#homebrew told me to do it
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    source /usr/local/share/bash-completion/bash_completion
fi
