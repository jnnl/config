setxkbmap fi

if type -p xcape &>/dev/null; then
    setxkbmap -option caps:ctrl_modifier
    xcape -e 'Caps_Lock=Escape' -t 10 &
else
    setxkbmap -option caps:escape
fi

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

xset r rate 250 35

eval $(ssh-agent)

export LESSHISTFILE=/dev/null

exec i3
