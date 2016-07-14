# bashrc
# General bash configs

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias tmux="tmux -2"

# OS X specific settings
if [[ $(uname) == "Darwin" ]]; then

    alias bup="brew update && brew upgrade && brew cleanup && brew doctor"
    alias gdb="sudo gdb -q"

    export TERM="xterm-256color"
    export PATH="$PATH:/usr/local/sbin"
    export VISUAL=vim
    export HOMEBREW_NO_ANALYTICS=1

    if [[ $(hostname) == "jmac" || $(hostname) == "jmac.local" ]]; then
        export PS1="\[\033[00m\]\u\[\033[m\]:\W $ "
    else
        export PS1="\[\033[00m\]\u\[\033[m\]@\h:\W $ "
    fi

fi
