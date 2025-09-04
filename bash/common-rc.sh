# man settings
export MANWIDTH=80
if type -t nvim >/dev/null; then
    export MANPAGER='nvim +Man! +normal\ gO'
fi
