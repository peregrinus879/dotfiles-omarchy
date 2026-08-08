# AGENTS.md - dotfiles-omarchy

Personal [Omarchy](https://github.com/basecamp/omarchy) dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/): targeted personal deviations stowed on top of the Omarchy desktop (Bash overrides in `bash/`, Hyprland application keybindings in `hypr/`, additive Neovim vault-workflow plugin specs in `nvim/`, Yazi config in `yazi/`). Omarchy, official docs, official package docs, and `DEVIATIONS.md` are the source of truth for default behavior and intentional differences; ownership boundaries live in `DEVIATIONS.md` (Deviation Policy and Out Of Scope).

## Load Map

- Claude Code loads this file through the root `CLAUDE.md` `@AGENTS.md` import; skills load on invocation only.
- The `Makefile` is the single source of the package list; `README.md` carries the human-facing setup, verification, and maintenance detail.
- Repo-root `.claude/settings.json` and `opencode.json` are per-tool project allowlists for this repo's verification make targets (`verify`, `lint`).

## Invariants

- Target machine: Omarchy; run stow and make targets only on the Omarchy host.
- When editing sibling dotfiles repos, use identical wording for shared concepts; only repo-specific values (scope, package lists, invariants) differ.
- The nvim vault plugin specs are byte-identical twins with `dotfiles-wsl`; `make verify` fails on drift.
- Omarchy must be installed and functional before applying these dotfiles; Yazi is installed separately (`sudo pacman -S yazi`).
- The vault is expected at `~/Projects/vault` (override with `OBSIDIAN_VAULT`) for the obsidian.nvim workflow.
- Git identity lives in the untracked per-host `~/.config/git/config.local`.
- `hypr/bindings.conf` preserves the Omarchy defaults layout at the top (deviations documented in `DEVIATIONS.md`) and appends personal bindings at the end.
- Keep every intentional difference documented in `DEVIATIONS.md`; update `README.md`, `AGENTS.md`, and `DEVIATIONS.md` together when ownership, setup, or sync assumptions change.
- Known Limitations records repo decisions and behavior official docs do not state; doc-derivable facts (defaults, version gates, upstream status) are fetched at change time, not cached here.

## Post-Change Verification

- Run `make verify` and `make lint` from the repo root after changing owned packages.
- Start a fresh shell and Neovim session after structural changes.
- The full human checklist lives in `README.md` (Verify and Maintenance).

## Known Limitations

- `omarchy-reinstall-configs` overwrites `~/.bashrc` and `~/.config/` from defaults; after running it, run `make recover`.

## Deferred Items

- watch basecamp/omarchy#5256 (upstream `tdl` DCS passthrough fix): when it merges, align the local `tdl` passthrough guard with upstream and update `DEVIATIONS.md`; the 50/50 split and second-AI-pane deviations stay regardless.

## Skills

- `/synchronize` - sync personal customizations against Omarchy references and official docs
