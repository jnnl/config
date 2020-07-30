# .bashrc

# skip if not running interactively
[[ $- != *i* ]] && return

# check if command exists
has() {
    type -p $* &>/dev/null
}

# print number of stopped jobs
nstopjobs() {
    n_stopped="$(jobs -ps 2>/dev/null | wc -l)"
    [ "$n_stopped" -gt 0 ] && printf " [%s]" "$n_stopped"
}

# cd to dirname
cdd() {
    cd "$(dirname $1)"
}

# selectively cd to shell wd
shd() {
    dir="$(pgrep -x bash | xargs -I_ readlink /proc/_/cwd | \
        sort -u | grep -Fvx "$(pwd)" | \
        fzf +s --height 40% --reverse)" && cd "$dir"
}

# selectively open man page by description
mano() {
    man -k . | fzf | awk '{print $1}' | xargs -r man
}

# prompt
test -f /usr/share/git/completion/git-prompt.sh && source $_
if has __git_ps1; then
    PS1="\u:\W\$(__git_ps1)\$(nstopjobs) $ "
else
    PS1="\u:\W\$(nstopjobs) $ "
fi

# aliases
alias l="ls -lhF"
alias ll="ls -lhAF"
alias lx="ls -lhAFX"

# shell options
shopt -s histappend

# command history options
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE=bg:cd:cdd:exit:shd:f:fg:l:ll:ls:v:z

# environment variables
export GIT_PS1_SHOWDIRTYSTATE=1
export PATH="$HOME/code/bin:$PATH"

# set nvim/vim as EDITOR
if has nvim; then
    alias vim=nvim
    export VISUAL=nvim EDITOR=nvim
elif has vim; then
    export VISUAL=vim EDITOR=vim
fi

# bash completion
if test -f /usr/share/bash-completion/bash_completion; then
    source "$_"
elif test -f /usr/local/share/bash-completion/bash_completion; then
    source "$_"
elif test -f /usr/local/etc/bash_completion; then
    source "$_"
elif test -f /etc/bash_completion; then
    source "$_"
fi

# fzf
test -f ~/.fzf.bash && source "$_"
if has fzf; then
    export FZF_DEFAULT_OPTS="--reverse --border"
    if has fd; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    elif has rg; then
        export FZF_DEFAULT_COMMAND="rg --files --hidden -g'!.git/'"
    fi
fi

# z
if test -f ~/.config/z/z.sh; then
    _Z_DATA="$HOME/.config/z/z"
    source ~/.config/z/z.sh
    f() {
        [ $# -gt 0 ] && _z "$*" && return
        cd "$(_z -l 2>&1 | \
            fzf --height 40% --nth 2.. --reverse --inline-info \
            +s --tac --query "${*##-* }" | \
            sed 's/^[0-9,.]* *//')"
    }
fi

# source local bashrc
test -f ~/.bashrc.local && source "$_"
