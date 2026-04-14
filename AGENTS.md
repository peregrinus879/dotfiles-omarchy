# AGENTS.md - dotfiles-omarchy

Personal [Omarchy](https://github.com/basecamp/omarchy) dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Omarchy, official docs, official package docs, and `DEVIATIONS.md` are the source of truth for default behavior and intentional differences.

## Scope

This repo carries standalone personal customizations for the Omarchy desktop. Omarchy manages its own defaults, themes, and desktop configs. This repo tracks only targeted personal deviations applied via GNU Stow.

It owns:

- personal Bash overrides in `bash/`
- personal Hyprland application keybindings in `hypr/`
- personal Neovim plugin additions in `nvim/`
- Yazi file manager config in `yazi/`

It does not own:

- Omarchy-managed defaults, themes, or desktop configs
- shared Linux baseline configs
- Hyprland system bindings, window rules, or desktop defaults
- Neovim options, shared plugins, or LazyVim configuration managed by `omarchy-nvim`

## Environment

- OS: Omarchy (Arch Linux + Hyprland)
- Terminal: Ghostty
- Dev: Tmux, Neovim (LazyVim), Bash

## Key Files

- `README.md` - package layout, setup, and verification
- `DEVIATIONS.md` - intentional deviations from Omarchy and boundary definitions
- `.claude/skills/synchronize/SKILL.md` - repo-specific sync workflow against upstream references

## Setup Invariants

- Omarchy must be installed and functional before applying these dotfiles
- `omarchy-nvim` must be set up first so `~/.config/nvim/lua/plugins/` exists as a real directory
- Yazi must be installed separately (`sudo pacman -S yazi`)
- Git identity is expected in the untracked local file `~/.config/git/config.local`
- `hypr/bindings.conf` preserves Omarchy defaults at the top with personal bindings appended at the end for easy diffing against upstream updates
- `omarchy-reinstall-configs` overwrites `~/.bashrc` and `~/.config/` from defaults; re-stow after running it

## Reference Sources

- `DEVIATIONS.md` for upstream GitHub URLs and boundary definitions
- `.claude/skills/synchronize/SKILL.md` for local reference repo paths and official docs

## Skills

- `/synchronize` - sync personal customizations against Omarchy references

## Workflow

- Use `/synchronize` when syncing personal customizations against Omarchy references
- Keep changes within the personal customization scope of this repo
- Keep all intentional differences documented in `DEVIATIONS.md`
- Update `README.md`, `AGENTS.md`, and `DEVIATIONS.md` together when ownership, setup, or sync assumptions change
- Keep shared Linux behavior and Omarchy defaults out of this repo
- `obsidian.lua` is maintained identically across dotfiles repos; apply changes to all copies

## Maintainer Checklist

1. Review the local reference repos and official docs for upstream changes to overridden items.
2. Use `/synchronize` or compare manually against the upstream references.
3. Confirm every intentional difference is still documented in `DEVIATIONS.md`.
4. Update `README.md` when package ownership, setup steps, or verification steps change.
5. Confirm the setup invariants still hold: Omarchy installed, `omarchy-nvim` set up, Yazi installed.
6. Start a fresh shell and Neovim session after structural changes to verify everything still loads cleanly.
