# .bashrc

# exit if not bash
test -n "$BASH" || exit 1

# check if command exists
has() {
    type -p $* &>/dev/null
}

# cd to dirname
cdd() {
    cd "$(dirname $1)"
}

# selectively cd to shell wd
d() {
    dir="$(pgrep -x bash | xargs -I_ readlink /proc/_/cwd | \
        sort -u | grep -Fvx "$(pwd)" | \
        fzf +s --height 40% --reverse)" && cd "$dir"
}

# selectively open man page by description
m() {
    apropos "" | fzf --height 40% --reverse -m | \
        tr -d "()" | awk '{print $2, $1}' | xargs -r man
}

# prompt
test -f /usr/share/git/completion/git-prompt.sh && source $_
if has __git_ps1; then
    PS1="\u:\W\$(__git_ps1) $ "
else
    PS1="\u:\W $ "
fi

# aliases
alias l="ls -lhF"
alias ll="ls -lhAF"

# shell options
shopt -s histappend

# command history options
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE=bg:cd:cdd:exit:d:f:fg:h:l:ll:ls:v:z

# configure environment
export GIT_PS1_SHOWDIRTYSTATE=1
export PATH="$HOME/code/bin:$PATH"

# set nvim/vim as EDITOR
if has nvim; then
    alias vim=nvim
    export VISUAL=nvim EDITOR=nvim
elif has vim; then
    export VISUAL=vim EDITOR=vim
elif has vi; then
    export VISUAL=vi EDITOR=vi
fi

# source bash completion
if test -f /usr/share/bash-completion/bash_completion; then
    source "$_"
elif test -f /usr/local/share/bash-completion/bash_completion; then
    source "$_"
elif test -f /usr/local/etc/bash_completion; then
    source "$_"
elif test -f /etc/bash_completion; then
    source "$_"
fi

# fzf config
test -f ~/.fzf.bash && source "$_"
if has fzf; then
    export FZF_DEFAULT_OPTS="--reverse --border"
    if has rg; then
        export FZF_DEFAULT_COMMAND="rg --files --hidden -g'!.git/'"
    elif has ag; then
        export FZF_DEFAULT_COMMAND="ag --hidden --ignore .git -f -g ''"
    fi
fi

# z config
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
