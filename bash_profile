# bash_profile
# OS X specific bash configs

[ -f ~/.bashrc ] && source ~/.bashrc

alias brewup="brew update && brew upgrade && brew cleanup && brew prune && brew doctor"
alias gdb="sudo gdb -q"

export TERM="xterm-256color"
export PATH="$PATH:/usr/local/sbin"
export COLORS=0
export VISUAL=vim
export HOMEBREW_CASK_OPTS="--appdir=~/Applications --caskroom=/usr/local/Caskroom"
export HOMEBREW_NO_ANALYTICS=1

if [[ $COLORS -eq 1 ]]; then
    export CLICOLOR=1
    export LSCOLORS=Hxxxxxxxhx
fi

if [[ $(hostname) == "jmac" || $(hostname) == "jmac.local" ]]; then
    export PS1="\[\033[00m\]\u\[\033[m\]:\W $ "
else
    export PS1="\[\033[00m\]\u\[\033[m\]@\h:\W $ "
fi
