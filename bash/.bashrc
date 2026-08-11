# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Personal overrides

# Launch Claude Code with ultracode; interactive aliases (cx, tdl targets) inherit via alias expansion
alias claude='claude --effort ultracode'

# Run claude without Omarchy's permission-bypass flag
alias cx='printf "\033[2J\033[3J\033[H" && claude'

# Run codex without Omarchy's sandbox-off and no-approval flags
alias cy='codex'

# Yazi cd-on-exit (Yazi is not part of Omarchy)
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
