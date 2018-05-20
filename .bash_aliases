#! /bin/bash
alias cd='cd -P'
alias cd='cl'
alias rm='rm -ri'
alias cp='cp -RHi'
alias mv='gmv -i'
alias mkdir='mkdir -p'
alias ..='cl ..'
alias df='df -h'
alias ln='ln -si'
alias disk='diskutil'
alias part='partutil'
alias dd='gdd status=progress bs=4M'
alias srit='source $HOME/.bashrc'
alias pbc='pbcopy'
alias grep='ggrep --color=auto'
alias dirs='dirs -v'
alias history='history | less'
alias du='du -xa | sort -rn'
alias stat='stat -Ll'
alias j='jobs'
alias f='fg'
alias g='grep'
alias ping='ping -c 1'
alias em='emacs'
alias goo='google'
alias webs='google webster'
alias sed='gsed'
alias e='echo -e'
alias less="$PAGER"
alias dircolors="gdircolors"
alias python="python3"
###################
#-------saved paths
###################
alias mackupdir='cd $(dirname $(readlink $HOME/.bashrc))'
alias abletondir='cd /Volumes/Izi/Ableton/_projects/time-killer\ Project'
###################
#--------ls aliases
###################
if [[ "$(uname -s)" =~ Darwin ]]; then
  #on mac use gnu ls. BSD ls: ls -Gph
  alias ls='gls -ph --color=always'
else
  alias ls='ls -ph --color=always'
fi
alias la='ls -A'
alias ll='ls -lSAi'
alias lt='ls -ltAi'
###################
#-----internet guys
###################
alias wget='wget -c'
alias histg="history | grep"
alias myip='curl http://ipecho.net/plain; echo'
###################
#-----brew and cask
###################
alias cask='brew cask'
alias brewi='brew info'
alias caski='brew cask info'
alias brewl='brew list'
alias caskl='brew cask list'
alias brews='brew search'
alias casks='brew cask search'
alias brewh='brew home'
alias caskh='brew cask home'
alias brewI='brew install'
alias caskI='brew cask install'
###################
#---------------git
###################
alias gits='git status'
alias gs='git status'
alias gitca='git commit -a'
alias gca='git commit -a'
alias gitc='git commit'
alias gitl='git log'
# alias gl='git log' #conflicts with "grep -l" gl func()
alias gith='git checkout'
alias gh='git checkout'
alias gita='git add'
alias gitaa='git add --all'
alias gitb='git branch'
alias gb='git branch'
alias gitd='git diff'
alias gitp='git push'
alias gp='git push'
alias gitm='git merge'
alias gitr='git reset'
alias gamend='git commit --amend'
###################
#--------bash files
###################
alias bashrc='code        ~/.bashrc'
alias bashaliases='code   ~/.bash_aliases'
alias bashfunctions='code ~/.bash_functions'
alias bashps1='code       ~/.bash_ps1'
###################
#----------mistakes
###################
alias loca='local'
alias emcas='emacs'
alias emasc='emcas'
alias me='emacs'
###################
#------------webdev
###################
alias caniuse='caniuse --mobile'
alias cani='caniuse'
alias mdn='google mdn'
alias watchsass="sass --watch css/index.sass:css/index.css 2>/dev/null 1>&2 &"
alias twoSpacesOnly="gsed -n -e '/^  [^ ]/p'"
alias webb="webbot.sh"
alias publi="publish.sh"
alias sshhost="ssh -p 21098 -i ~/.ssh/id_rsa tazemuad@server179.web-hosting.com"
alias sshh="sshhost"
alias sftphost="sftp -P 21098 -i ~/.ssh/id_rsa tazemuad@server179.web-hosting.com"
alias gpglist="gpg --list-secret-keys --keyid-format LONG"
alias gpgexport="gpg --armor --export"
alias gpgkeygen="gpg --full-generate-key"
alias simplePrompt="PS1='\n\[\e[1;90m\w \e[0m\]\n$ '"
alias npml="npm list --depth=0"
alias npmgl="npm list --global --depth=0"
alias npms="npm search"
alias npmh="npm repo"
alias npmI="npm install"
