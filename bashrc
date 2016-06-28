# bashrc
# General bash configs

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if which tput > /dev/null 2>&1 && [[ $(tput -T$TERM colors) -ge 8 ]]; then
    export TERMCOLORS=1
else
    export TERMCOLORS=0
fi
