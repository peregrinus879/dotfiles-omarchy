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
- [The Omarchy Manual](https://learn.omacom.io/2/the-omarchy-manual) - setup guides, keybindings, workflows
- [obsidian-nvim/obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) - upstream for the vault plugin spec
- [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) - upstream for the markdown rendering spec
- [sxyazi/yazi](https://github.com/sxyazi/yazi) and the [Yazi docs](https://yazi-rs.github.io/docs/) - file manager upstream and configuration reference
- [GNU Stow manual](https://www.gnu.org/software/stow/manual/stow.html) - symlink management and package structure

## Intentional Deviations

### Bash

- `.bashrc` opens with the upstream quattro preamble (sources `/etc/omarchy.conf` when present, defaults `OMARCHY_PATH` to `/usr/share/omarchy`, and sources `$OMARCHY_PATH/default/bash/rc`), then adds personal overrides below. The preamble is upstream-authored, written through the stow symlink by the quattro upgrade, and is kept verbatim.
- Interactive Bash exports `OPENCODE_DISABLE_EXTERNAL_SKILLS=1` and `OPENCODE_ENABLE_EXA=1` so terminal-launched OpenCode selects its managed skills and exposes its configured web-search tool. `dotfiles-ai` owns OpenCode configuration; this repo owns the Omarchy host environment. Non-interactive launchers supply both variables explicitly.
- `claude` is aliased to add `--effort ultracode`, so every interactive launch, including `cx` and `tdl`-launched AIs, inherits it via alias expansion; scripts and hooks stay plain. Ultracode is session-only upstream and cannot be set in `settings.json`.
- `EDITOR=nvim` is exported, overriding the Omarchy quattro default (`omarchy-launch-editor --inline`), so `dw`, tmux, and git resolve the editor deterministically.
- `y()` is added for Yazi cd-on-exit support. Yazi is not part of Omarchy.
- `dw` is added: one tmux session per project (Git root, else current directory) with two windows: a full-width AI agent (`dw cc` for Claude Code, `dw oc` for OpenCode; the choice is mandatory at creation so a single agent owns the working tree) and `$EDITOR` above a 25% shell. `-c` continues that agent's last conversation in the project; bare `dw` re-attaches an existing session. Additive alongside Omarchy's `tdl`/`tds` pane layouts; tracked as a byte-identical twin with `dotfiles-wsl`.

### Hyprland

- `bindings.lua` is the only tracked Hyprland file: personal overrides, loaded after the Omarchy defaults through the Omarchy-owned `~/.config/hypr/hyprland.lua` require chain. No defaults are replicated.
- The twelve default web-app bindings (ChatGPT, Grok, Calendar, Email, New email, YouTube, WhatsApp, Google Messages, Google Photos, Google Maps, X, X Post) are retired via `hl.unbind`; the personal `SUPER ALT` web-app set replaces them (Claude, Gmail, GitHub, LinkedIn, CFI, M365 Copilot, ChatGPT, Proton, Teams, WhatsApp, X, YouTube).
- `SUPER SHIFT A` launches the AppImages manager, taking the key from the default ChatGPT web app.
- `SUPER ALT G` launches Gmail, taking the key from the default "move window out of group" tiling binding; that default is knowingly sacrificed.
- The pre-quattro personal Tmux binding is dropped: quattro's `SUPER ALT RETURN` default is functionally identical (tmux attach or new "Work" session in the terminal cwd).
- The preinstalled app and TUI bindings (Music, Docker, Signal, Obsidian, Omawrite, Passwords, Herdr, Tmux) stay on Omarchy defaults.
- All other Hyprland config (`hyprland.lua`, `monitors.lua`, `input.lua`, `looknfeel.lua`, `autostart.lua`) is Omarchy-owned and untracked; machine-local values (display resolution and scale, keyboard layouts, touchpad scrolling) live there directly.

### Neovim

- `omarchy-nvim` owns the base Neovim config. This repo adds two additive plugin specs for the vault workflow, adopted from the vault's former `nvim-vault` package.
- `obsidian.lua` configures obsidian.nvim against the vault at `~/Projects/vault` (override with `OBSIDIAN_VAULT`), including slug-rename and promote workflows that shell out to the vault's `normalize.py`, plus confirm-prompted delete workflows.
- `render-markdown.lua` adds visual markdown rendering; a companion, not required by obsidian.nvim.
- Runtime dependencies beyond the base install: `ripgrep`, `python3`, and `wl-clipboard`, all present on Omarchy.
- The spec carries a WSL-guarded `open.func` override that routes URIs through Windows interop; it is inert on Omarchy, where the default `vim.ui.open` applies. Both repos track byte-identical copies of the spec.
- `theme.lua` in `~/.config/nvim/lua/plugins/` stays Omarchy-managed by the theme system and is not tracked here.

### Yazi

- Added entirely. Yazi is not part of Omarchy.
- `yazi.toml` carries local layout and behavior choices: ratio `[2, 4, 4]`, hidden files shown, directories sorted first, `sort_by = "natural"`, and `linemode = "size"`. Tracked as a byte-identical twin with `dotfiles-wsl`.
- No theme file is tracked. Omarchy manages themes.

## Out Of Scope

The following do **not** belong in `dotfiles-omarchy`:

- Shared Linux baseline configs (out of scope)
- WSL or Windows-specific behavior (belong in `dotfiles-wsl`)
- AI harness configs (belong in `dotfiles-ai`)
- The vault itself, its scripts, or its sync (belong to the vault project)
- Omarchy system bindings, window rules, or desktop defaults (belong in Omarchy)
