# AGENTS.md - dotfiles-omarchy

Personal [Omarchy](https://github.com/basecamp/omarchy) dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/): targeted personal deviations stowed on top of the Omarchy desktop (Bash overrides in `bash/`, Hyprland application keybindings in `hypr/`, additive Neovim vault-workflow plugin specs in `nvim/`, Yazi config in `yazi/`). Omarchy, official docs, official package docs, and `DEVIATIONS.md` are the source of truth for default behavior and intentional differences; ownership boundaries live in `DEVIATIONS.md` (Deviation Policy and Out Of Scope).

## Load Map

- Claude Code loads this file through the root `CLAUDE.md` `@AGENTS.md` import; skills load on invocation only.
- The `Makefile` is the single source of the package list; `README.md` carries the human-facing setup, verification, and maintenance detail.
- Repo-root `.claude/settings.json` and `opencode.json` are per-tool project allowlists for this repo's verification make targets (`verify`, `lint`).

## Invariants

- Target machine: Omarchy; run stow and make targets only on the Omarchy host.
- When editing sibling dotfiles repos, use identical wording for shared concepts; only repo-specific values (scope, package lists, invariants) differ.
- The Makefile `TWIN_SPECS` files (nvim vault plugin specs, the `dw` workspace function, `yazi.toml`) are byte-identical twins with `dotfiles-wsl`; `make verify` fails on drift.
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

- `omarchy-reinstall-configs` and `omarchy-refresh-config` copy defaults with no symlink awareness, writing through stow symlinks into this repo's files; if either runs, `git restore` the clobbered repo files first, then run `make recover`. The quattro version (`cp -af /etc/skel/. ~/`) behaves the same way.
- Stow tree-folds `~/.config/yazi` into a directory symlink pointing at the repo, so anything written there lands in the repo working tree; folding is the accepted repo-family stow convention (do not add `--no-folding`).

## Deferred Items

- Omarchy 4.0 quattro (unreleased, one-way upgrade): wait for the stable release, re-diff the quattro branch first, then follow the runbook in `~/Projects/scratch/2026-08-11-omarchy-quattro-upgrade-runbook.md`. Headlines: the upgrade rewrites `~/.bashrc` through the stow symlink (commit the upstream-authored diff), and the Lua cutover makes `hypr/bindings.conf` dead config (port personal bindings to `bindings.lua`, then rewrite the DEVIATIONS Hyprland section).
- upstream `tdl` on the dev/quattro branches ends with `select-pane -t "$opencode_pane"` on an unset variable (focus regression introduced alongside `tds`); after the 4.0 update, verify the installed `tdl` before relying on it.
- close or rework basecamp/omarchy#5256 (the `tdl` passthrough-guard PR from this account); the local guard was removed as ineffective on 2026-08-11.
- watch the tree-folded `~/.config/yazi`: the first `ya pkg` install writes `plugins/` and `package.toml` into the repo working tree; decide then whether to track them (the `dotfiles-ai` opencode-deps pattern) or gitignore them (the `dotfiles-wsl` git-identity pattern).

## Skills

- `/synchronize` - sync personal customizations against Omarchy references and official docs
