#!/bin/bash
# Guarded stow preparation for dotfiles-omarchy (make clean / make recover).
#
# Removes only what this repo owns: symlinks (including tree-folded directory
# links) that resolve into this repo, and regular files sitting at owned file
# paths, which on Omarchy are expected clobber artifacts (omarchy-refresh-* and
# the quattro upgrade write real files through or over stowed links). Anything
# else at an owned path is unrecognized and aborts the run untouched.
set -euo pipefail

repo=$(realpath -e -- "$(dirname -- "${BASH_SOURCE[0]}")/..")

# Tree-folded parents first, deepest first, so per-file removals below never
# resolve through a folded link into the repo working tree.
fold_dirs=(
  ~/.config/bash/functions
  ~/.config/bash
  ~/.config/nvim/lua/plugins
  ~/.config/nvim/lua
  ~/.config/nvim
  ~/.config/yazi
)

owned_files=(
  ~/.bashrc
  ~/.config/hypr/bindings.lua
  ~/.config/hypr/monitors.lua
  ~/.config/yazi/yazi.toml
  ~/.config/bash/functions/dw
  ~/.config/bash/functions/hdw
  ~/.config/nvim/lua/plugins/obsidian.lua
  ~/.config/nvim/lua/plugins/render-markdown.lua
)

abort() {
  echo "ABORT: $1" >&2
  exit 1
}

resolves_into_repo() {
  local resolved
  resolved=$(readlink -f -- "$1") || return 1
  [[ $resolved == "$repo"/* ]]
}

for d in "${fold_dirs[@]}"; do
  if [[ -L $d ]]; then
    resolves_into_repo "$d" || abort "$d is a symlink that does not resolve into this repo; refusing to remove it"
    rm -- "$d"
    echo "removed: $d (folded link into the repo)"
  fi
done

for f in "${owned_files[@]}"; do
  if [[ -L $f ]]; then
    resolves_into_repo "$f" || abort "$f is a symlink that does not resolve into this repo; refusing to remove it"
    rm -- "$f"
    echo "removed: $f (owned link)"
  elif [[ -f $f ]]; then
    # A regular file resolving into the repo can only be reached through a
    # symlinked parent; deleting it would delete repo working-tree content.
    if resolves_into_repo "$f"; then
      abort "$f is a regular file that resolves into this repo through a symlinked parent; refusing to remove it"
    fi
    rm -f -- "$f"
    echo "removed: $f (regular file at an owned path, Omarchy clobber artifact)"
  elif [[ -e $f ]]; then
    abort "$f exists but is neither a symlink nor a regular file; refusing to remove it"
  fi
done
