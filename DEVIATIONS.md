# Deviations

## Purpose

This document records the intentional differences carried by `dotfiles-omarchy` relative to [Omarchy](https://github.com/basecamp/omarchy) defaults, and defines the boundary between personal desktop customizations and Omarchy-managed behavior.

Omarchy remains the upstream reference. This repo carries only targeted personal deviations applied via GNU Stow.

## Deviation Policy

Omarchy manages its own defaults, themes, and desktop configs. This repo sources those defaults and adds personal customizations on top.

**Guiding principles:**

1. **Source Omarchy defaults first.** Personal overrides come after Omarchy defaults are loaded, not instead of them.
2. **Keep customizations minimal and targeted.** Only override what needs personal customization. Do not replicate Omarchy behavior.
3. **Keep scope to personal desktop customizations.** Shared Linux baseline behavior and headless adaptations are out of scope.
4. **No theme customizations.** Omarchy manages themes. This repo does not track theme files.
5. **Additive Neovim plugin specs only.** `omarchy-nvim` owns the base Neovim config; this repo adds vault-workflow plugin specs on top without touching base options.

## Reference Sources

- [basecamp/omarchy](https://github.com/basecamp/omarchy) - main Omarchy repo for defaults, themes, and desktop configs

## Intentional Deviations

### Bash

- `.bashrc` sources Omarchy defaults from `~/.local/share/omarchy/default/bash/rc`, then adds personal overrides below.
- `cx` alias drops Omarchy's permission-bypass flag (currently `--permission-mode bypassPermissions` upstream).
- `y()` is added for Yazi cd-on-exit support. Yazi is not part of Omarchy.
- `tdl` uses a 50/50 editor/AI split in the top 85% with a 15% bottom terminal pane, replacing Omarchy's 70/30 split.
- `tdl` guards AI panes with per-pane `allow-passthrough off` during initialization, restoring it after 1 second. This prevents DCS passthrough responses from being misrouted to the editor pane during the focus transition.
- `tdl` supports an optional second AI pane.

### Hyprland

- `bindings.conf` preserves Omarchy default application bindings at the top for easy diffing against upstream.
- Personal application bindings are appended after the defaults and commented-out examples.
- Personal desktop app shortcut: `SUPER SHIFT, A` for AppImages launcher.
- Personal web app shortcuts use `SUPER ALT` prefix (Claude, Gmail, GitHub, LinkedIn, ChatGPT, Teams, Proton, WhatsApp, X, YouTube, CFI, M365 Copilot).

### Neovim

- `omarchy-nvim` owns the base Neovim config. This repo adds two additive plugin specs for the vault workflow, adopted from the vault's former `nvim-vault` package.
- `obsidian.lua` configures obsidian.nvim against the vault at `~/Projects/vault` (override with `OBSIDIAN_VAULT`), including the slug-rename, promote, and delete workflows that shell out to the vault's `normalize.py`.
- `render-markdown.lua` adds visual markdown rendering; a companion, not required by obsidian.nvim.
- Runtime dependencies beyond the base install: `ripgrep`, `python3`, and `wl-clipboard`, all present on Omarchy.
- `theme.lua` in `~/.config/nvim/lua/plugins/` stays Omarchy-managed by the theme system and is not tracked here.

### Yazi

- Added entirely. Yazi is not part of Omarchy.
- `yazi.toml` carries local layout and behavior choices: ratio `[2, 4, 4]`, hidden files shown, directories sorted first, `sort_by = "natural"`, and `linemode = "size"`.
- No theme file is tracked. Omarchy manages themes.

## Out Of Scope

The following do **not** belong in `dotfiles-omarchy`:

- Shared Linux baseline configs (out of scope)
- WSL or Windows-specific behavior (belong in `dotfiles-wsl`)
- AI harness configs (belong in `dotfiles-ai`)
- Omarchy system bindings, window rules, or desktop defaults (belong in Omarchy)
