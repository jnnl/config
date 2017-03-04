# bashrc
# General bash config

# Get current git branch for PS1
get_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -z "$SSH_CONNECTION" ]; then
    export PS1="\u:\W\$(get_git_branch) $ "
else
    export PS1="\u@\h:\W $ "
fi

alias ll="ls -lahF"
export TERM="xterm-256color"
export HISTCONTROL=ignoredups

# Linux-specific settings
if [[ $(uname) == "Linux" ]]; then
    alias gdb="gdb -q"

    export PATH="$PATH:"$HOME"/code/bin"
    export SUDO_EDITOR=vim
fi

# MacOS-specific settings
if [[ $(uname) == "Darwin" ]]; then
    alias bup="brew update && brew upgrade && brew cleanup && brew doctor"
    alias gdb="sudo gdb -q"

    export PATH="$PATH:/usr/local/sbin:"$HOME"/code/bin"
    export HOMEBREW_NO_ANALYTICS=1
fi
