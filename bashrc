# bashrc
# jnnl.net

[ -z "$BASH" ] && return

[ -f "$HOME"/.fzf.bash ] && source "$HOME"/.fzf.bash

if [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

function _git_br() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# https://github.com/justinmk/config/blob/master/.bashrc
function bd() {
    new_dir=$(echo $(pwd) | sed 's|\(.*/'$1'[^/]*/\).*|\1|')
    index=$(echo $new_dir | awk '{ print index($1,"/'$1'"); }')
    if [ $index -eq 0 ]; then
        echo "No such occurrence."
    else
        echo $new_dir
        cd "$new_dir"
    fi
}

HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="bg:fg:exit:ls:ll:cd"
SHELL_SESSION_HISTORY=0

type -p fzf rg &>/dev/null && \
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'

type -p vim &>/dev/null && export EDITOR=vim MANPAGER="vim '+set ft=man noma' -"
type -p nvim &>/dev/null && export EDITOR=nvim MANPAGER="nvim '+set ft=man noma' -"

export PATH="$PATH:"$HOME"/code/bin"

if [ -z "$SSH_CONNECTION" ]; then
    PS1="\u:\W\$(_git_br) $ "
else
    PS1="\u@\h:\W\$(_git_br) $ "
fi

alias ll="ls -lahF"

# Linux-specific settings
if [[ $(uname) == "Linux" ]]; then
    alias gdb="gdb -q"
fi

# macOS-specific settings
if [[ $(uname) == "Darwin" ]]; then
    alias bup="brew update && brew upgrade && brew cleanup && brew doctor"
    alias gdb="sudo gdb -q"
    export HOMEBREW_NO_ANALYTICS=1
fi
