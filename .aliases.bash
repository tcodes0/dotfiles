#! /usr/bin/env bash
###############
#-------general
###############
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
alias srit='source $HOME/.bashrc && clear'
alias pbc='pbcopy'
alias pbp='pbpaste'
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
alias sed='gsed'
alias e='echo -e'
alias less="\$PAGER"
alias dircolors="gdircolors"
alias python="python3"
alias ncdu="ncdu -x --si"
alias visudo="EDITOR=emacs && sudo visudo"
alias shfmt="shfmt -i 2 -ln bash"
alias shellcheck="shellcheck --color=auto -s bash"
alias cat='bat --theme Monokai\ Extended\ Origin'
alias gppr='gpsup && hub pull-request --browse'
alias gpprd='gpsup && hub pull-request --base develop --browse'
alias hpr='hub pull-request'
alias hprl='hub pr list'
alias hprc='hub pr checkout'
alias hprs='hub pr show'
alias hisl="hub issue -a thomazella -M \$MILESTONE"
alias hisa='hub issue -l '
alias his='hub issue'
alias cleoskylin="cleos -u http://kylin.fn.eosbixin.com"
alias emulator="\$HOME/Library/Android/sdk/emulator/emulator"
alias find="gfind"
################
#-------cd stuff
################
alias .d="cd \$HOME/Desktop"
alias .c="cd \$HOME/Code"
alias mackupdir='cd $(dirname $(readlink $HOME/.bashrc))'
alias abletondir='cd /Volumes/Izi/Ableton/_projects/time-killer\ Project'
####################
#--------mac aliases
####################
if [[ "$(uname -s)" =~ Darwin ]]; then
  #on mac use gnu ls. BSD ls: ls -Gph
  alias ls='gls -ph --color=always'
  alias rn='react-native'
  alias rns='nvm use lts/* && react-native start'
  alias rnsr='nvm use lts/* && react-native start --reset-cache'
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
###########
#-----brew
###########
alias brewi='brew info'
alias brewl='brew list'
alias brews='brew search'
alias brewh='brew home'
alias brewI='brew install'
alias brewR='brew uninstall'
###########
#-----cask
###########
alias cask='brew cask'
alias caski='brew cask info'
alias caskl='brew cask list'
alias casks='brew search'
alias caskh='brew cask home'
alias caskI='brew cask install'
alias caskR='brew cask uninstall'
###################
#--------bash files
###################
alias bashrc='code        ~/.zshrc'
alias bashaliases='code   ~/.aliases.bash'
alias bashfunctions='code ~/.functions.bash'
alias bashps1='code       ~/.prompt.bash'
###################
#----------mistakes
###################
alias loca='local'
alias emcas='emacs'
alias emasc='emcas'
alias me='emacs'
alias ndoe='node'
alias yy='yarn'
###################
#---------Zsh & Git
###################
alias ...="cl ../../"
alias ....="cl ../../../"
alias .....="cl ../../../../"
alias ......="cl ../../../../../"
alias git="hub"
# alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gapp='git apply'
alias gap='git add --patch'
alias gau='git add --update'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^(\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gc='git commit'
alias gca='git commit -v -a'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcd='git checkout develop'
alias gcf='git config --list'
alias gcl='git clone --recursive'
alias gclean='git clean -fd'
# alias gcmsg='git commit -m' using function
alias gco='git checkout'
alias gcom='git fetch --all --prune && git checkout master'
alias gcod='git fetch --all --prune && git checkout develop'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit -S'
alias gcsm='git commit -s -m'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdct='git describe --tags `git rev-list --tags --max-count=1`'
alias gdcw='git diff --cached --word-diff'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
# alias gf='git fetch'
alias gf='git fetch --all --prune'
alias gfo='git fetch origin'
alias gg='git gui citool'
alias gga='git commit --amend --no-edit'
alias ggae='git commit --amend'
alias ggpull="git pull origin \$GIT_BRANCH"
# alias ggpull="git pull origin \$__git_ps1_branch_name"
alias ggpur=ggu
alias ggpush="git push origin \$GIT_BRANCH"
# alias ggpush="git push origin \$__git_ps1_branch_name"
alias ggsup="git branch --set-upstream-to=origin/\$GIT_BRANCH"
# alias ggsup="git branch --set-upstream-to=origin/\$__git_ps1_branch_name"
alias gpf='git push foton'
alias ghh='git help'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
alias gk='\gitk --all --branches'
alias gke='\gitk --all $(git log -g --pretty=%h)'
alias gl='git pull'
alias gly='git pull && yarn'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat -p'
alias glo='git log --oneline --decorate'
alias globurl='noglob urlglobber '
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all'
alias glp='_git_log_prettily'
alias glum='git pull upstream master'
alias gm='git merge -q'
alias gma='git merge --abort'
alias gmom='git fetch --all --prune && git merge -q origin/master'
alias gmod='git fetch --all --prune && git merge -q origin/develop'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge -q upstream/master'
alias gmsq='git merge -q --squash'
alias gp='git push -q'
alias gpo='git push origin'
alias gpd='git push --dry-run'
alias gpoat='git push origin --all && git push origin --tags'
alias gpristine='git reset --hard && git clean -dfx'
alias gpsup="git push -q --set-upstream origin \$GIT_BRANCH"
alias gpsupf="git push -q --set-upstream foton \$GIT_BRANCH"
# alias gpsup="git push -q --set-upstream origin \$__git_ps1_branch_name"
alias gpu='git push upstream'
alias gpv='git push -v'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grh1="git reset HEAD~1"
alias grh2="git reset HEAD~2"
alias grh3="git reset HEAD~3"
alias gco1="git checkout HEAD~1"
alias gco2="git checkout HEAD~2"
alias gco3="git checkout HEAD~3"
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'
alias gsb='git status -sb'
alias gsd='git svn dcommit'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gsu='git submodule update'
alias gtl='git tag -l'
alias gtd='git tag -d'
alias gta='git tag'
alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'
alias grev='git revert'
alias gnuke='git reset HEAD --hard && git clean -fd'
alias wip="git add --all && git commit -nm wip"
alias grl="git reflog"
###################
#------------dev
###################
alias caniuse='caniuse --mobile'
alias cani='caniuse'
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
alias gpgremove="gpg --delete-secret-key"
alias simplePrompt="PS1='\\n\\[\\e[1;90m\\w \\e[0m\\]\\n$ ' && PROMPT_COMMAND=''"
alias npml="npm list --depth=0"
alias npmgl="npm list --global --depth=0"
alias npms="npm search"
alias npmh="npm repo"
alias npmI="npm install"
alias y="yarn"
alias yarnl="yarn list --depth=0"
alias yarngl="yarn global list --depth=0"
alias adbI="adb install"
alias adbl="adb devices"
alias adbd="adb shell input keyevent 82"
alias rnra="react-native run-android"
alias acceptAllLicenses="yes | \$HOME/Library/Android/sdk/tools/bin/sdkmanager --licenses"
alias snoop='echo sudo opensnoop -ve 2>&1 PIPE g idea.properties'
alias clearIapCache="adb shell pm clear com.android.vending"
alias c.="code ."
alias c="code"
alias lgl="echo build ci chore docs feat fix perf refactor revert style test"
alias macinstall="echo sudo /Applications/Install\ macOS\ Catalina\ Beta.app/Contents/Resources/createinstallmedia --volume /Volumes/USB /Applications/Install\ macOS\ Catalina\ Beta.app --nointeraction"
alias ytw="yarn test --watch"
alias yt="yarn test"
alias ism="iex -S mix"