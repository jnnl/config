# .bashrc

# skip if not running interactively
[[ $- != *i* ]] && return

# check if command exists
has() {
    type -p $* &>/dev/null
}

# cd to dirname
cdd() {
    cd "$(dirname ${1:-$PWD})"
}

# cd to selected shell wd
cdsh() {
    local dir="$(pgrep -x bash | xargs -I_ readlink /proc/_/cwd | \
        sort -u | grep -Fvx "$PWD" | \
        fzf +s --reverse)" && cd "$dir"
}

# cd to git root
cdgr() {
    local dir="$(git rev-parse --show-toplevel)" && cd "$dir"
}

# browse man pages by name and description
mana() {
    man -k . | fzf | awk '{print $1}' | xargs -r man
}

# browse git commits
gcb() {
  git log --graph --color=always --date=short \
      --format="%C(yellow)%h %Cgreen%ad %Cblue%aN%Cred%d %Creset%s" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# kill selected process
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    [ -n "$pid" ] && echo $pid | xargs kill -${1:-9}
}

# print compacted wd path
compact_pwd() {
    local pathsep="/"
    local trunclen="1"
    local triglen="20"

    if test "${#PWD}" -lt "$triglen"; then
        printf "$PWD"
        return
    fi

    local path=""
    mapfile -td "$pathsep" wd_parts < <(printf "%s\0" "$PWD")
    for part in "${wd_parts[@]:1:${#wd_parts[@]}-2}"; do
        path="$path$pathsep${part::trunclen}"
    done
    path="$path$pathsep${wd_parts[-1]}"
    printf "$path"
}

# print number of stopped jobs
__nstopjobs() {
    n_stopped="$(jobs -ps 2>/dev/null | wc -l)"
    test "$n_stopped" -gt 0 && printf " [%s]" "${n_stopped#${n_stopped%%[![:space:]]*}}"
}

# prompt
if test -f /usr/share/git/completion/git-prompt.sh; then
    source "$_"
elif test -f /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh; then
    source "$_"
fi
if has __git_ps1; then
    PS1="\u:\W\$(__git_ps1)\$(__nstopjobs) $ "
else
    PS1="\u:\W\$(__nstopjobs) $ "
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
        test $# -gt 0 && _z "$*" && return
        cd "$(_z -l 2>&1 | \
            fzf --height 40% --nth 2.. --reverse --inline-info \
            +s --tac --query "${*##-* }" | \
            sed 's/^[0-9,.]* *//')"
    }
fi

# source local bashrc
test -f ~/.bashrc.local && source "$_"
