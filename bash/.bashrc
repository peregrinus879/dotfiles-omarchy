# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

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
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Dev Workspace launcher (twin file with dotfiles-wsl)
[[ -f ~/.config/bash/functions/dw ]] && source ~/.config/bash/functions/dw
