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
alias tra='trash'
alias disk='diskutil'
alias part='partutil'
alias dd='gdd status=progress bs=4M'
alias srit='source $HOME/.bashrc'
alias pbc='pbcopy'
alias grep='gfgrep --color=auto'
alias dirs='dirs -v'
alias history='history | less'
alias du='du -xa | sort -rn'
alias stat='stat -Ll'
alias j='jobs'
alias f='fg'
alias g='grep -e'
alias ping='ping -c 1'
alias em='emacs'
#------------------
#-------saved paths
#------------------
alias mackupdir='cd $(dirname $(readlink $HOME/.bashrc))'
alias abletondir='cd /Volumes/Izi/Ableton/_projects/major-minor-rmk\ Project'
#------------------
#--------ls aliases
#------------------
alias ls='ls -Gph'
alias la='ls -A'
alias ll='ls -lSAi'
#------------------
#-----internet guys
#------------------
alias wget='wget -c'
alias histg="history | grep"
alias myip='curl http://ipecho.net/plain; echo'
#------------------
#-----brew and cask
#------------------
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
#------------------
#---------------git
#------------------
alias gits='git status'
alias gs='git status'
alias gitca='git commit -a'
alias gca='git commit -a'
alias gitc='git commit'
alias gitl='git log'
alias gl='git log'
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
#------------------
#--------bash files
#------------------
alias bashrc='emacs ~/.bashrc'
alias bashaliases='emacs ~/.bash_aliases'
alias bashfunctions='emacs ~/.bash_functions'
alias bashps1='emacs ~/.bash_ps1'
#------------------
#----------mistakes
#------------------
alias loca='local'
alias emcas='emacs'
alias emasc='emcas'
alias me='emacs'
#------------------
#------------webdev
#------------------
alias rendercss='npx postcss *.css --use autoprefixer --dir ./css --watch 2>/dev/null 1>&2 &'
alias caniuse='caniuse --mobile'
