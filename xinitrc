[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

setxkbmap fi
setxkbmap -option caps:escape

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

eval $(ssh-agent)

export LESSHISTFILE=/dev/null

exec i3
