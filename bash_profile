# .bash_profile

autostartx() {
    [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
}
#autostartx

test -f ~/.bashrc && source ~/.bashrc
