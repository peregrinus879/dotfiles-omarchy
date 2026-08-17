# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Personal overrides

# Keep OpenCode on managed skills and expose its configured web-search tool
export OPENCODE_DISABLE_EXTERNAL_SKILLS=1
export OPENCODE_ENABLE_EXA=1

# Pin the editor; quattro defaults EDITOR to "omarchy-launch-editor --inline"
export EDITOR=nvim

# Launch Claude Code with ultracode; interactive aliases (cx, tdl targets) inherit via alias expansion
alias claude='claude --effort ultracode'

# Yazi cd-on-exit (Yazi is not part of Omarchy)
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Dev Workspace launcher (twin file with dotfiles-wsl)
[[ -f ~/.config/bash/functions/dw ]] && source ~/.config/bash/functions/dw
