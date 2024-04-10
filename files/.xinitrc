# .xinitrc

setxkbmap fi

if type -p xcape &>/dev/null; then
    setxkbmap -option caps:ctrl_modifier
    xcape -e 'Caps_Lock=Escape' &
else
    setxkbmap -option caps:escape
fi

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge -I~ ~/.Xresources

xset r rate 250 35

eval $(ssh-agent)

export LESSHISTFILE=/dev/null
export WINIT_HIDPI_FACTOR=1

exec i3
