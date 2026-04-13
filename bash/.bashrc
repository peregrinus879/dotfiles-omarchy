# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Personal overrides

# Run claude without --allow-dangerously-skip-permissions
alias cx='printf "\033[2J\033[3J\033[H" && claude'

# Yazi cd-on-exit (Yazi is not part of Omarchy)
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Custom tdl: 50/50 editor/AI split + DCS passthrough guard
# (Omarchy default is 70/30 without passthrough guard)
# Usage: tdl <c|cx|other_ai> [<second_ai>]
tdl() {
  [[ -z $1 ]] && { echo "Usage: tdl <c|cx|other_ai> [<second_ai>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }

  local current_dir="${PWD}"
  local editor_pane ai_pane ai2_pane
  local ai="$1"
  local ai2="$2"

  editor_pane="$TMUX_PANE"

  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  # Terminal at bottom 15%
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"

  # AI on right 50%
  ai_pane=$(tmux split-window -h -p 50 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  # Block DCS passthrough on AI panes during init to prevent terminal capability
  # responses from being misrouted to the editor pane during the focus transition
  tmux set-option -p -t "$ai_pane" allow-passthrough off

  # If second AI provided, split the AI pane vertically
  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux set-option -p -t "$ai2_pane" allow-passthrough off
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  tmux send-keys -t "$ai_pane" "$ai" C-m
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
  tmux select-pane -t "$editor_pane"

  # Restore passthrough after AI TUI init completes (DCS queries finish)
  { sleep 1
    tmux set-option -p -t "$ai_pane" allow-passthrough on 2>/dev/null
    [[ -n $ai2_pane ]] && tmux set-option -p -t "$ai2_pane" allow-passthrough on 2>/dev/null
  } &
  disown
}
