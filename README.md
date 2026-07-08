# dotfiles-omarchy

Personal [Omarchy](https://github.com/basecamp/omarchy) dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

`dotfiles-omarchy` carries standalone personal customizations for the Omarchy desktop. Omarchy manages its own defaults, themes, and desktop configs. This repo tracks only targeted personal deviations applied via GNU Stow.

## Repo Family

Derivation model for this repo family:

```text
AI harness configs              → dotfiles-ai
Omarchy + personal deviations   → dotfiles-omarchy
Omarchy + WSL deviations        → dotfiles-wsl
```

- [`dotfiles-ai`](https://github.com/peregrinus879/dotfiles-ai) - AI harness configs: Claude Code and OpenCode settings, shared guidance, and commit workflow
- [`dotfiles-omarchy`](https://github.com/peregrinus879/dotfiles-omarchy) - Personal Omarchy customizations: Bash overrides, Hyprland bindings, Neovim plugins, and Yazi
- [`dotfiles-wsl`](https://github.com/peregrinus879/dotfiles-wsl) - Self-contained WSL Arch dotfiles: terminal baseline plus Windows Terminal, clipboard integration, and OpenCode theme

## Stack

- **Base**: [Omarchy](https://github.com/basecamp/omarchy)
- **Bash**: Personal alias and function overrides on top of Omarchy defaults
- **Editor**: [obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) and [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) plugin specs on the `omarchy-nvim` base
- **File Manager**: [Yazi](https://github.com/sxyazi/yazi) (not part of Omarchy)
- **Desktop**: [Hyprland](https://github.com/hyprwm/Hyprland) personal application keybindings

## Package Layout

Each top-level directory is a GNU Stow package that symlinks into `$HOME`:

```text
bash/   Bash overrides (.bashrc with Omarchy defaults sourced + personal additions)
hypr/   Hyprland personal application keybindings (bindings.conf)
nvim/   Additive Neovim plugin specs for the vault workflow (obsidian.lua, render-markdown.lua)
yazi/   Yazi file manager config (yazi.toml, no theme)
```

Key ownership rules:

- Omarchy manages all defaults, themes, and desktop configs
- `bash/` owns `~/.bashrc`, sources Omarchy defaults, and adds personal overrides below
- `yazi/` is purely additive since Yazi is not part of Omarchy
- `nvim/` is purely additive plugin specs on top of the `omarchy-nvim` base; the vault is expected at `~/Projects/vault` (override with `OBSIDIAN_VAULT`)
- `hypr/` owns `~/.config/hypr/bindings.conf` with Omarchy defaults preserved and personal application bindings appended at the end
- no theme files are tracked; Omarchy manages themes

## Setup

### 1. Prerequisites

Omarchy must be installed and functional.

Install Yazi (not part of Omarchy):

```bash
sudo pacman -S yazi
```

### 2. Clone

Recommended local layout for this repo family:

```text
~/Projects/repos/dotfiles/dotfiles-omarchy
```

Stow can work from any clone location, but the related docs and cross-repo maintenance workflows assume this layout.

```bash
git clone https://github.com/peregrinus879/dotfiles-omarchy.git ~/Projects/repos/dotfiles/dotfiles-omarchy
```

### 3. Prepare

Checklist before stowing:

- Omarchy is installed and functional
- Yazi is installed
- The vault is synced to `~/Projects/vault` (or `OBSIDIAN_VAULT` is set) if you use the Obsidian workflow
- Any existing conflicting files were removed

Remove existing files that would conflict with stow:

```bash
rm -f ~/.bashrc
rm -f ~/.config/hypr/bindings.conf
rm -f ~/.config/nvim/lua/plugins/obsidian.lua
rm -f ~/.config/nvim/lua/plugins/render-markdown.lua
rm -f ~/.config/yazi/yazi.toml
```

### 4. Stow

Create symlinks for all packages:

```bash
cd ~/Projects/repos/dotfiles/dotfiles-omarchy
stow -v -t ~ bash hypr nvim yazi
```

Start a new terminal session, or run `source ~/.bashrc`, for the shell config to take effect.

### Unstow

```bash
cd ~/Projects/repos/dotfiles/dotfiles-omarchy
stow -D -v -t ~ bash hypr nvim yazi
```

### Dry Run

Preview what stow would do without making changes:

```bash
cd ~/Projects/repos/dotfiles/dotfiles-omarchy
stow -v -n -t ~ bash hypr nvim yazi
```

### Re-stow

To update symlinks after the repo content changes (same clone path):

```bash
cd ~/Projects/repos/dotfiles/dotfiles-omarchy
stow -R -v -t ~ bash hypr nvim yazi
```

To migrate from a different clone path, unstow from the old location first:

```bash
cd /old/clone/path
stow -D -v -t ~ bash hypr nvim yazi
cd ~/Projects/repos/dotfiles/dotfiles-omarchy
stow -v -t ~ bash hypr nvim yazi
```

If the old clone is no longer available, run the full cleanup in section 3 before stowing.

### Recovery After `omarchy-reinstall-configs`

`omarchy-reinstall-configs` overwrites `~/.bashrc` and `~/.config/` from Omarchy defaults. After running it, re-stow:

```bash
rm -f ~/.bashrc ~/.config/hypr/bindings.conf ~/.config/yazi/yazi.toml \
  ~/.config/nvim/lua/plugins/obsidian.lua ~/.config/nvim/lua/plugins/render-markdown.lua
cd ~/Projects/repos/dotfiles/dotfiles-omarchy
stow -R -v -t ~ bash hypr nvim yazi
```

## Verify

After stowing:

- Confirm the configs resolve into the repo clone: run `make verify` from the repo root. Stow may tree-fold `~/.config/yazi` into a directory symlink, so per-file `test -L` checks can false-negative.
- Start a fresh shell and confirm `type cx` shows `claude` without a permission-bypass flag.
- Confirm `type tdl` shows the custom 50/50 split and passthrough guard.
- Confirm `type y` shows the Yazi cd-on-exit function.
- Run `yazi` and confirm the layout ratio and sort order match the config.
- Open a vault note in Neovim and confirm obsidian.nvim loads (`<leader>oo` opens the note switcher).

## Maintenance

A repo-root `Makefile` keeps the package list in one place and wraps the routine commands. Run targets from the repo root on the Omarchy machine:

- `make stow` / `make unstow` / `make dry-run` / `make restow` - the stow command sets from Setup
- `make verify` - the Verify symlink checks plus bash syntax
- `make clean` - the Prepare cleanup steps
- `make recover` - the Recovery steps after `omarchy-reinstall-configs` (clean + restow)
- `make lint` - ShellCheck over the bash package; `.shellcheckrc` disables the pre-existing upstream-derived warnings so new issues stand out

`make stow`, `make restow`, and `make recover` finish with a forced `hyprctl reload` plus a `hyprctl configerrors` check when run inside a Hyprland session. Hyprland's config watcher can reload mid-swap while stow is relinking `bindings.conf` and cache a stale sourcing error; the forced reload clears it and fails loudly on real errors. `make verify` includes the same error check read-only.

## References

- `README.md` - package layout, setup, and verification
- `Makefile` - stow, verification, cleanup, and recovery automation
- `DEVIATIONS.md` - intentional deviations from Omarchy and boundary definitions
- `AGENTS.md` - canonical repo-specific assistant context and maintainer checklist
- `CLAUDE.md` - thin Claude Code wrapper importing `AGENTS.md`

## Related Repos

Clone these locally if you plan to use `/synchronize` or compare against upstream references. The `/synchronize` skill expects reference repos under `~/Projects/repos/references/`.

- `~/Projects/repos/references/omarchy` - upstream Omarchy reference repo

## Credits

Personal customizations on top of [Omarchy](https://github.com/basecamp/omarchy). See [DEVIATIONS.md](DEVIATIONS.md) for intentional differences and boundary definitions.

## License

[MIT](LICENSE)
