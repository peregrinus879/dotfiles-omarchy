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
- Interactive Bash exports `OPENCODE_DISABLE_EXTERNAL_SKILLS=1` and `OPENCODE_ENABLE_EXA=1` so terminal-launched OpenCode uses its managed skills and exposes web search. `dotfiles-ai` owns OpenCode configuration; this repo owns the Omarchy host environment. Non-interactive launchers supply the same variables explicitly.
- `hypr/bindings.conf` preserves the Omarchy defaults layout at the top (deviations documented in `DEVIATIONS.md`) and appends personal bindings at the end; `hypr/bindings.lua` carries the quattro successor (personal overrides only, loaded after the defaults), inert until the 4.0 Lua cutover.
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

- Omarchy 4.0 quattro upgrade (released 2026-08-14, one-way): run imminently via Update > Omarchy (to 3.8.5), then Update > Omarchy To Quattro. Gates before rebooting: both repos clean and pushed, `sudo snapper list` shows working snapshots, and `sudo limine-snapper-list` shows the script's pre-upgrade snapshot number. Post-upgrade sequence, in order: `make recover` first (`make verify` is red until the upgrade-replaced `bindings.lua` symlink is restored), commit the upstream-authored `~/.bashrc` diff (written through the stow symlink) together with the DEVIATIONS Bash source-path bullet it invalidates, then retire `bindings.conf` with the full README/AGENTS/DEVIATIONS Hyprland rewrite. The 2026-08-11 scratch runbook is superseded by the sparred plan except its WSL follow-up section.
- upstream `tdl` still ends with `select-pane -t "$opencode_pane"` on a variable it never sets, verified at v4.0.0 `default/bash/fns/tmux` on 2026-08-15 (cosmetic focus regression; `post-4.0-fixes` does not touch it).
- close or rework basecamp/omarchy#5256 (the `tdl` passthrough-guard PR from this account); the local guard was removed as ineffective on 2026-08-11.
- watch the tree-folded `~/.config/yazi`: the first `ya pkg` install writes `plugins/` and `package.toml` into the repo working tree; decide then whether to track them (the `dotfiles-ai` opencode-deps pattern) or gitignore them (the `dotfiles-wsl` git-identity pattern).
- watch `~/.local/bin` on quattro: the upgrade and every `omarchy-refresh-applications` run `rm -f` hand-installed CLIs (claude, codex, opencode, gemini, copilot, ghui, pi, playwright, and more) and rewrite them as lazy mise wrappers; record versions before the upgrade and verify each wrapper after.
- quattro migration 1786539345 symlinks a `diagnose-crash` skill into `~/.claude/skills` and `~/.codex/skills` via `ln -sfn`; coordinate ownership with `dotfiles-ai` after the upgrade.

## Skills

- `/synchronize` - sync personal customizations against Omarchy references and official docs
