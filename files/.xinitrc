# .xinitrc

setxkbmap fi

if ! type -p caps2esc &>/dev/null; then
    if type -p xcape &>/dev/null; then
        setxkbmap -option caps:ctrl_modifier
        xcape -e 'Caps_Lock=Escape' &
    else
        setxkbmap -option caps:escape
    fi
fi

test -f ~/.Xmodmap && xmodmap ~/.Xmodmap
test -f ~/.Xresources && xrdb -merge -I~ ~/.Xresources

xset r rate 250 35

eval $(ssh-agent)

export LESSHISTFILE=/dev/null
export WINIT_HIDPI_FACTOR=1

exec i3
