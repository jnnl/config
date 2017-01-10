setxkbmap fi
setxkbmap -option caps:escape

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

xset r rate 250 35

eval $(ssh-agent)

export LESSHISTFILE=/dev/null

exec i3
