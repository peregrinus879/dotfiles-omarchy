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
5. **No Neovim plugins in this repo.** `omarchy-nvim` owns the base Neovim config.

## Reference Sources

- [basecamp/omarchy](https://github.com/basecamp/omarchy) - main Omarchy repo for defaults, themes, and desktop configs

## Intentional Deviations

### Bash

- `.bashrc` sources Omarchy defaults from `~/.local/share/omarchy/default/bash/rc`, then adds personal overrides below.
- `cx` alias drops Omarchy's `--allow-dangerously-skip-permissions` flag.
- `y()` is added for Yazi cd-on-exit support. Yazi is not part of Omarchy.
- `tdl` uses a 50/50 editor/AI split in the top 85% with a 15% bottom terminal pane, replacing Omarchy's 70/30 split.
- `tdl` guards AI panes with per-pane `allow-passthrough off` during initialization, restoring it after 1 second. This prevents DCS passthrough responses from being misrouted to the editor pane during the focus transition.
- `tdl` supports an optional second AI pane.

### Hyprland

- `bindings.conf` preserves Omarchy default application bindings at the top for easy diffing against upstream.
- Personal application bindings are appended after the defaults and commented-out examples.
- Personal desktop app shortcut: `SUPER SHIFT, A` for AppImages launcher.
- Personal web app shortcuts use `SUPER ALT` prefix (Claude, Gmail, GitHub, LinkedIn, ChatGPT, Teams, Proton, WhatsApp, X, YouTube, CFI, M365 Copilot).

### Yazi

- Added entirely. Yazi is not part of Omarchy.
- `yazi.toml` carries local layout and behavior choices: ratio `[2, 4, 4]`, hidden files shown, and directories sorted first.
- No theme file is tracked. Omarchy manages themes.

## Out Of Scope

The following do **not** belong in `dotfiles-omarchy`:

- Shared Linux baseline configs (out of scope)
- WSL or Windows-specific behavior (belong in `dotfiles-wsl`)
- AI harness configs (belong in `dotfiles-ai`)
- Omarchy system bindings, window rules, or desktop defaults (belong in Omarchy)
