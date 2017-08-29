# bashrc
# jnnl.net

# exit if not bash
[ -z "$BASH" ] && exit

# get git branch
function _git_br {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# backwards cd
function bd {
    local new_dir="$(pwd | sed "s|\(.*/$1[^/]*/\).*|\1|")"
    if [ -d "$new_dir" ]; then
        echo "$new_dir"
        cd "$new_dir"
    else
        echo "No such occurrence."
    fi
}

# create directory and enter it
function mcd {
    mkdir -p "$@" && cd "$1"
}

# check if command exists
function has {
    type -p "$@" &>/dev/null
}

# show hostname in prompt if in ssh session
if [ -z "$SSH_CONNECTION" ]; then
    PS1="\u:\W\$(_git_br) $ "
else
    PS1="\u@\h:\W\$(_git_br) $ "
fi

# aliases
alias l="ls -lhF | sed '1d'"
alias ll="ls -lahF"
alias f=z
has hub && alias git=hub

# Linux-specific settings
if [[ $(uname -s) = Linux ]]; then
    # Arch-specific settings
    if grep -qi archlinux /etc/os-release; then
        alias s="sudo pacman -S"
        alias sss="sudo pacman -Ss"
        alias syu="sudo pacman -Syu"
        alias q="pacman -Q"
        alias qi="pacman -Qi"
        alias qs="pacman -Qs"
    fi

    alias gdb="gdb -q"
fi

# macOS-specific settings
if [[ $(uname -s) = Darwin ]]; then
    alias bi="brew install"
    alias br="brew remove"
    alias bu="brew update && brew upgrade && brew cleanup --prune=7"
    alias gdb="sudo gdb -q"
    alias python="python3"

    export HOMEBREW_NO_ANALYTICS=1
fi

# shell options
shopt -s histappend
shopt -s cdspell

# command history options
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="bg:cd:exit:f:fg:l:ll:ls:v:z"

# add custom bin directory to path
export PATH="$HOME/code/bin:$PATH"

# set nvim (or vim) as editor
has vim && export VISUAL=vim EDITOR=vim
has nvim && export VISUAL=nvim EDITOR=nvim

# source bash completion
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
fi

# source fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--no-height --no-reverse'

# source z
[ -f "$HOME/.config/z/z.sh" ] && source "$HOME/.config/z/z.sh"
has z && export _Z_DATA="$HOME/.config/z/z"

# source local bashrc
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
