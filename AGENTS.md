# AGENTS.md - dotfiles-omarchy

Personal [Omarchy](https://github.com/basecamp/omarchy) dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Omarchy, official docs, and official package docs are the source of truth for default behavior.

## Scope

This repo carries standalone personal customizations for the Omarchy desktop. Omarchy manages its own defaults, themes, and desktop configs. This repo tracks only targeted personal deviations applied via GNU Stow.

It owns:

- personal Bash overrides in `bash/`
- personal Hyprland application keybindings in `hypr/`
- personal Neovim plugin additions in `nvim/`
- Yazi file manager config in `yazi/`

It does not own:

- Omarchy-managed defaults, themes, or desktop configs
- shared Linux baseline configs from `dotfiles-arch`
- Hyprland system bindings, window rules, or desktop defaults
- Neovim options, shared plugins, or LazyVim configuration managed by `omarchy-nvim`

## Environment

- OS: Omarchy (Arch Linux + Hyprland)
- Terminal: Ghostty
- Dev: Tmux, Neovim (LazyVim), Bash

## Key Files

- `README.md` - package layout, setup steps, and verification
- `.claude/skills/synchronize/SKILL.md` - repo-specific sync workflow against Omarchy references

## Setup Invariants

- Omarchy must be installed and functional before applying these dotfiles
- `omarchy-nvim` must be set up first so `~/.config/nvim/lua/plugins/` exists as a real directory
- Yazi must be installed separately (`sudo pacman -S yazi`)
- Git identity is expected in the untracked local file `~/.config/git/config.local`
- `hypr/bindings.conf` preserves Omarchy defaults at the top with personal bindings appended at the end for easy diffing against upstream updates
- `omarchy-reinstall-configs` overwrites `~/.bashrc` and `~/.config/` from defaults; re-stow after running it

## Reference Sources

- `/synchronize` expects local reference repos under the canonical `~/projects/repos/references/` root
- `~/projects/repos/references/omarchy` - main repo for bash, tmux, and general Omarchy references
- `~/projects/repos/references/omarchy-pkgs` - package builds, including the Omarchy Neovim package
- `~/projects/repos/dotfiles/dotfiles-arch` - shared headless baseline for deviation parity checks

## Skills

- `/synchronize` - sync personal customizations against Omarchy references

## Workflow

- Use `/synchronize` when syncing personal customizations against Omarchy references
- Keep changes within the personal customization scope of this repo
- Update `README.md` and `AGENTS.md` together when ownership, setup, or sync assumptions change
- Keep shared Linux behavior in `dotfiles-arch`, not here
- Keep Omarchy default behavior in Omarchy, not here

## Maintainer Checklist

1. Review `omarchy` and `omarchy-pkgs` references for upstream changes to overridden items.
2. Use `/synchronize` to compare personal customizations against upstream references.
3. Update `README.md` when package ownership, setup steps, or verification steps change.
4. Confirm the setup assumptions still hold: Omarchy installed, `omarchy-nvim` set up, Yazi installed.
5. Start a fresh shell and Neovim session after structural changes to verify customizations still apply cleanly.
