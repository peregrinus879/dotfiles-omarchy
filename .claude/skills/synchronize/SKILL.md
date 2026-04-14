---
name: synchronize
description: Sync personal Omarchy customizations against upstream references and dotfiles-arch for deviation parity.
---

# Synchronize

Source configs from Omarchy references and `dotfiles-arch`, compare against `dotfiles-omarchy`, and apply changes only where they belong in the personal customizations.

## Sources

### Reference Repos

Reference repos live under `~/projects/repos/references/`:

- `omarchy/` - main repo for bash, tmux, and general Omarchy defaults
- `omarchy-pkgs/` - package builds, including the Omarchy Neovim package

### Local Baseline

- `~/projects/repos/dotfiles/dotfiles-arch` - shared headless baseline for deviation parity checks

### Official Docs

- [The Omarchy Manual](https://learn.omacom.io/2/the-omarchy-manual) - setup guides, keybindings, workflows
- [LazyVim Docs](https://www.lazyvim.org/) - installation and plugin conventions
- [Neovim Docs](https://neovim.io/doc/) - options and Lua reference
- [lazy.nvim Docs](https://lazy.folke.io/) - plugin manager configuration
- [Yazi Docs](https://yazi-rs.github.io/docs/) - configuration and themes
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html) - symlink management and package structure

## When To Use

- Use this skill when Omarchy or a reference repo changed materially.
- Use this skill when personal customization scope or behavior changed materially.
- Use this skill when you suspect undocumented drift between this repo and its references.
- Use this skill before broad sync-oriented doc updates.

## Workflow

1. Compare `bash/.bashrc` overrides against the current Omarchy defaults in `omarchy/default/bash/`:
   - `cx` alias against `omarchy/default/bash/aliases`
   - `tdl` function against `omarchy/default/bash/fns/tmux`
   - `y()` function is additive (Yazi is not in Omarchy)
2. Compare `nvim/` plugin files against `omarchy-pkgs/` and `dotfiles-arch/nvim/`:
   - `obsidian.lua` against `dotfiles-arch/nvim/.config/nvim/lua/plugins/obsidian.lua`
   - `render-markdown.lua` against `dotfiles-arch/nvim/.config/nvim/lua/plugins/render-markdown.lua`
   - Verify no filename collisions with new `omarchy-nvim` plugin files
3. Compare `hypr/bindings.conf` against `omarchy/config/hypr/bindings.conf`:
   - Omarchy default bindings at the top should match upstream
   - Personal bindings at the end are user customizations
4. Compare `yazi/yazi.toml` against `dotfiles-arch/yazi/.config/yazi/yazi.toml` and official Yazi docs
5. For each difference, classify it:
   - **Intentional personal customization**: should stay different
   - **New upstream addition**: added after the last sync, should be reviewed
   - **Upstream change to existing config**: modified upstream, needs review
6. Check `git log --format="%h %ad %s" --date=short -- <file>` on the relevant reference repo when you need to determine when a difference was introduced
7. Apply new upstream changes where they belong in the personal customizations
8. Update `README.md` and `AGENTS.md` when package ownership, setup steps, or sync assumptions change
9. Summarize which changes were adopted, rejected, or intentionally kept different

## Completion Checks

- `README.md` and `AGENTS.md` reflect any ownership, setup, or workflow changes
- The final summary distinguishes adopted changes, rejected changes, and intentional personal customizations

## Rules

- Present proposed changes to the user before editing
- Omarchy, official docs, and official package docs are the source of truth for default behavior
- Always check all relevant sources, not just one
- Do not copy Omarchy default behavior into this repo if Omarchy already manages it
- Keep the Neovim additions additive: `omarchy-nvim` owns the base config, this repo only adds personal plugins
- Keep the Bash overrides minimal: source Omarchy defaults, only override what needs to change
- Keep Yazi config standalone since Yazi is not part of Omarchy
