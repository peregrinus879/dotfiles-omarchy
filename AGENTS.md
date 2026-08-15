# AGENTS.md - dotfiles-omarchy

Personal [Omarchy](https://github.com/basecamp/omarchy) dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/): targeted personal deviations stowed on top of the Omarchy desktop (Bash overrides in `bash/`, Hyprland application keybindings in `hypr/`, additive Neovim vault-workflow plugin specs in `nvim/`, Yazi config in `yazi/`). Omarchy, official docs, official package docs, and `DEVIATIONS.md` are the source of truth for default behavior and intentional differences; ownership boundaries live in `DEVIATIONS.md` (Deviation Policy and Out Of Scope).

## Load Map

- Claude Code loads this file through the root `CLAUDE.md` `@AGENTS.md` import; skills load on invocation only.
- The `Makefile` is the single source of the package list; `README.md` carries the human-facing setup, verification, and maintenance detail.
- `docs/maintenance.md` is the on-demand ledger (known limitations, deferred items, dated findings); read it before package removals, Omarchy updates or refreshes, or work on a deferred item.

## Invariants

- Target machine: Omarchy; run stow and make targets only on the Omarchy host.
- When editing sibling dotfiles repos, use identical wording for shared concepts; only repo-specific values (scope, package lists, invariants) differ.
- The Makefile `TWIN_SPECS` files (nvim vault plugin specs, the `dw` workspace function, `yazi.toml`) are byte-identical twins with `dotfiles-wsl`; `make verify` fails on drift.
- Omarchy must be installed and functional before applying these dotfiles; Yazi is installed separately (`sudo pacman -S yazi`).
- The vault is expected at `~/Projects/vault` (override with `OBSIDIAN_VAULT`) for the obsidian.nvim workflow.
- Git identity lives in the untracked per-host `~/.config/git/config.local`.
- Interactive Bash exports `OPENCODE_DISABLE_EXTERNAL_SKILLS=1` and `OPENCODE_ENABLE_EXA=1` so terminal-launched OpenCode uses its managed skills and exposes web search. `dotfiles-ai` owns OpenCode configuration; this repo owns the Omarchy host environment. Non-interactive launchers supply the same variables explicitly.
- `hypr/bindings.lua` carries personal Hyprland overrides only (the twelve default web-app bindings retired via `hl.unbind`, the personal `SUPER ALT` set and AppImages added), loaded after the Omarchy defaults; no defaults are replicated (deviations documented in `DEVIATIONS.md`).
- Keep every intentional difference documented in `DEVIATIONS.md`; update `README.md`, `AGENTS.md`, and `DEVIATIONS.md` together when ownership, setup, or sync assumptions change.

## Post-Change Verification

- Run `make verify` and `make lint` from the repo root after changing owned packages.
- Start a fresh shell and Neovim session after structural changes.
- The full human checklist lives in `README.md` (Verify and Maintenance).

## Skills

- `/omasync` - sync personal customizations against Omarchy references, installed defaults, and official docs
