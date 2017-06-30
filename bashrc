# bashrc
# jnnl.net

[ -z "$BASH" ] && exit  # exit if not bash

# get git branch
function _git_br {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}


# backwards cd
function bd {
    new_dir="$(pwd | sed "s|\(.*/$1[^/]*/\).*|\1|")"
    if [ -d "$new_dir" ]; then
        echo "$new_dir"
        cd "$new_dir"
    else
        echo "No such occurrence."
    fi
}

function mcd {
    mkdir -p "$@" && cd "$@"
}

function has {
    type -p "$@" &>/dev/null
}

if [ -z "$SSH_CONNECTION" ]; then
    PS1="\u:\W\$(_git_br) $ "
else
    PS1="\u@\h:\W\$(_git_br) $ "
fi

alias l="ls -lhF | sed '1d'"
alias ll="ls -lahF"
alias f=z
has hub && alias git=hub

# Linux-specific settings
if [[ $(uname -s) = Linux ]]; then
    if grep -qi archlinux /etc/os-release; then
        alias s="sudo pacman -S"
        alias ss="sudo pacman -Ss"
        alias syu="sudo pacman -Syu"
        alias q="pacman -Q"
        alias qi="pacman -Qi"
        alias qs="pacman -Qs"
        alias sys="systemctl"
        alias mpv="mpv --user-agent='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.104 Safari/537.36'"
    fi
    alias gdb="gdb -q"
fi

# macOS-specific settings
if [[ $(uname -s) = Darwin ]]; then
    alias bi="brew install"
    alias br="brew remove"
    alias bu="brew update && brew upgrade && brew cleanup"
    alias gdb="sudo gdb -q"
    alias python="python3"

    export HOMEBREW_NO_ANALYTICS=1
fi

if [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

shopt -s histappend
shopt -s cdspell

HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="bg:fg:exit:ls:ll:l:cd:z:f:v"

if [ -d "$HOME/.cargo/bin" ] && [[ $PATH != *cargo/bin* ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi
export PATH="$HOME/projects/gatling/bin:$PATH"
export PATH="$HOME/code/bin:$HOME/.gem/ruby/2.4.0/bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "$HOME/.config/z/z.sh" ] && source "$HOME/.config/z/z.sh"

export FZF_DEFAULT_OPTS='--no-height --no-reverse'

has vim && export EDITOR=vim
has nvim && export EDITOR=nvim
has z && export _Z_DATA="$HOME/.config/z/z"
