#========== Environment
export PATH=$PATH:/usr/local/sbin:/Users/vamac/bin
export HISTFILESIZE=3000
export HISTSIZE=3000
export CDPATH=/Users/vamac:/Volumes:/
export HISTTIMEFORMAT="%b %d "
export HISTCONTROL="ignoredups:erasedups"
export TIMEFORMAT=$'\n-time elapsed-\nreal\t%3Rs\nuser\t%3Us\nsystem\t%3Ss'
export BLOCKSIZE=1000000
export EDITOR='/usr/bin/emacs'
export PAGER='/usr/bin/less'
export TMZLCOLOR="\e[0;49;35m"
shopt -s autocd cdspell dirspell globstar lithist histverify
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
#========== Misc
#homebrew told me to do it
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    source /usr/local/share/bash-completion/bash_completion
fi
