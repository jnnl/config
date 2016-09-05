# bashrc
# General bash configs

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias tmux="tmux -2"

# OS X specific settings
if [[ $(uname) == "Darwin" ]]; then

    get_git_branch() {
        git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }

    alias bup="brew update && brew upgrade && brew cleanup && brew doctor"
    alias gdb="sudo gdb -q"
    alias dim="vim +'colorscheme tantalum-dark'"
    alias bim="vim +'call JColorToggle()'"

    export TERM="xterm-256color"
    export PATH="$PATH:/usr/local/sbin:/Users/juho/code/bin"
    export VISUAL=vim
    export HOMEBREW_NO_ANALYTICS=1

    if [[ $(hostname) == "jmac" || $(hostname) == "jmac.local" ]]; then
        export PS1="\u:\W\$(get_git_br) $ "
    else
        export PS1="\u@\h:\W\$(get_git_br) $ "
    fi

fi
