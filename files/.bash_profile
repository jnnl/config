# .bash_profile

autostartx() {
    [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
}
#autostartx

[ -f ~/.bashrc ] && source ~/.bashrc
