---
name: omasync
description: Sync personal Omarchy customizations against upstream references, installed defaults, and official docs.
---

# Omasync

Source configs from the installed Omarchy defaults, the reference repos, and official docs, compare against `dotfiles-omarchy`, and apply changes only where they belong in the personal customizations.

## Sources

Local reference clones live under `~/Projects/repos/references/`:

- `omarchy/` - main repo for bash, tmux, and general Omarchy defaults; tracks the upstream default branch, which upstream moves between releases (re-resolve with `git remote set-head origin -a`, then match the checkout), so pin release comparisons to the installed version's tag (`git show v4.0.0:<path>`)
- `obsidian.nvim/` - obsidian.nvim upstream for the vault plugin spec

The installed defaults the machine actually runs live under `/usr/share/omarchy` (package-backed since quattro). Upstream URLs, official docs, and descriptions live in `DEVIATIONS.md` (Reference Sources).

## When To Use

- Use this skill when Omarchy or a reference repo changed materially, including after an Omarchy update or a config refresh ran.
- Use this skill when personal customization scope or behavior changed materially.
- Use this skill when you suspect undocumented drift between this repo and its references.
- Use this skill before broad sync-oriented doc updates.

## Workflow

1. Update the reference clones: for each repo under `~/Projects/repos/references/`, run `git remote set-head origin -a`, match the checkout to the resolved default branch, `git fetch --prune --tags && git pull --ff-only`, and confirm `HEAD` equals `origin/<default>`.
2. Compare `bash/.bashrc` overrides against the current Omarchy defaults in `omarchy/default/bash/`:
   - `cx` alias against `omarchy/default/bash/aliases`
   - `tdl` function against `omarchy/default/bash/fns/tmux`
   - `y()` function is additive (Yazi is not in Omarchy)
3. Compare `hypr/bindings.lua` against the installed quattro defaults at `/usr/share/omarchy/default/hypr/bindings/` (`applications.lua` carries the app and web-app set) and the user seed at `/usr/share/omarchy/config/hypr/bindings.lua`:
   - every `hl.unbind` target must still match a default chord, and personal chords must not collide with new defaults (`omarchy menu keybindings --print` shows the live merge)
   - verify live registration by description and modmask via `hyprctl binds`; quattro registers Lua bindings as opaque `__lua` dispatchers, so exec strings never appear there
   - the file stays personal overrides only; defaults are never replicated
4. Compare `yazi/yazi.toml` against official Yazi docs, and the `nvim/` plugin specs against `obsidian.nvim/` and the render-markdown.nvim README
5. App parity sweep: diff `pacman -Qe` against the installed default manifest (`/usr/share/omarchy/install/omarchy-base.packages` plus hardware conditionals) and the optional installers (`omarchy-install-*`); classify each extra as personal, optional-installed, or retired survivor, and account for provider resolution (`extra/neovim` satisfies the `nvim` entry)
6. Tool-path integrity: every managed CLI in `~/.local/bin` (claude, codex, opencode, gemini, copilot, gh, and the rest) must be the Omarchy mise wrapper; `omarchy-refresh-applications` deletes and rewrites them, so verify with `head -3` on each and `mise ls`. Hand-installed scripts are unmanaged and survive. Old native install stores are removable only after confirming the running binary path via `/proc/<pid>/exe`
7. Webapp entries: compare the webapp launchers in `~/.local/share/applications` against the current Omarchy default set and remove stale ones with `omarchy-webapp-remove`; personal bindings launch by URL and do not depend on desktop entries
8. For each difference, classify it:
   - **Intentional personal customization**: documented in `DEVIATIONS.md`, should stay different
   - **New upstream addition**: added upstream after the last sync, should be reviewed for inclusion
   - **Upstream change to existing config**: modified upstream, needs review
9. Check `git log --format="%h %ad %s" --date=short -- <file>` on the relevant reference repo when you need to determine when a difference was introduced
10. Cross-check differences against `DEVIATIONS.md`. If a difference is not documented there, treat it as a likely upstream change that needs review
11. Apply new upstream additions and changes where they belong in the personal customizations
12. Update `README.md`, `AGENTS.md`, and `DEVIATIONS.md` when package ownership, setup steps, or documented deviations change
13. Summarize which changes were adopted, rejected, or intentionally kept different

## Completion Checks

- `README.md`, `AGENTS.md`, and `DEVIATIONS.md` reflect any ownership, setup, or workflow changes
- Every retained difference is still documented in `DEVIATIONS.md`
- The final summary distinguishes adopted changes, rejected changes, and intentional retained differences

## Rules

- Present proposed changes to the user before editing
- Omarchy, official docs, official package docs, and `DEVIATIONS.md` are the source of truth for default behavior and intentional differences
- Always check all relevant sources, not just one
- Never assume a difference is intentional without verifying it is documented in `DEVIATIONS.md`
- Do not copy Omarchy default behavior into this repo if Omarchy already manages it
- Keep the Bash overrides minimal: source Omarchy defaults, only override what needs to change
- Keep Yazi config standalone since Yazi is not part of Omarchy
- Package removals: the pacman dependency graph is necessary but not sufficient; also check runtime plugin loading (`qt5-wayland`/`qt6-wayland` style), tools exec'd by Omarchy scripts (`grep -r` the `/usr/share/omarchy` tree), and .NET framework targets (`*.runtimeconfig.json` against installed runtimes)
- `qt6-wayland` reads as a pacman orphan but carries Quickshell and every Qt6 app at runtime; never remove `pacman -Qdtq` output as a batch
