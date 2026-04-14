# dotfiles-omarchy

Personal [Omarchy](https://github.com/basecamp/omarchy) dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

`dotfiles-omarchy` carries standalone personal customizations for the Omarchy desktop. Omarchy manages its own defaults, themes, and desktop configs. This repo tracks only targeted personal deviations applied via GNU Stow.

## Repo Family

- [`dotfiles-ai`](https://github.com/peregrinus879/dotfiles-ai) - AI harness configs: Claude Code and OpenCode settings, shared guidance, and commit workflow
- [`dotfiles-arch`](https://github.com/peregrinus879/dotfiles-arch) - Shared Arch Linux terminal baseline: Bash, Tmux, Neovim, Starship, Git, Yazi, btop, and fastfetch
- [`dotfiles-wsl`](https://github.com/peregrinus879/dotfiles-wsl) - WSL overlay for dotfiles-arch: Windows Terminal, clipboard integration, and repo auto-refresh
- [`dotfiles-omarchy`](https://github.com/peregrinus879/dotfiles-omarchy) - Personal Omarchy customizations: Bash overrides, Hyprland bindings, Neovim plugins, and Yazi

## Stack

- **Base**: [Omarchy](https://github.com/basecamp/omarchy)
- **Bash**: Personal alias and function overrides on top of Omarchy defaults
- **Editor**: [Neovim](https://github.com/neovim/neovim) ([LazyVim](https://github.com/LazyVim/LazyVim)) plugin additions on top of `omarchy-nvim`
- **File Manager**: [Yazi](https://github.com/sxyazi/yazi) (not part of Omarchy)
- **Desktop**: [Hyprland](https://github.com/hyprwm/Hyprland) personal application keybindings

## Package Layout

Each top-level directory is a GNU Stow package that symlinks into `$HOME`:

```text
bash/   Bash overrides (.bashrc with Omarchy defaults sourced + personal additions)
hypr/   Hyprland personal application keybindings (bindings.conf)
nvim/   Neovim plugin additions (obsidian.nvim with custom slugs and keybindings, render-markdown.nvim)
yazi/   Yazi file manager config (yazi.toml, no theme)
```

Key ownership rules:

- Omarchy manages all defaults, themes, and desktop configs
- `bash/` owns `~/.bashrc`, sources Omarchy defaults, and adds personal overrides below
- `nvim/` adds plugin files to the existing `~/.config/nvim/lua/plugins/` directory managed by `omarchy-nvim`
- `yazi/` is purely additive since Yazi is not part of Omarchy
- `hypr/` owns `~/.config/hypr/bindings.conf` with Omarchy defaults preserved and personal application bindings appended at the end
- no theme files are tracked; Omarchy manages themes

## Setup

### 1. Prerequisites

Omarchy must be installed and functional. `omarchy-nvim` must be set up so `~/.config/nvim/lua/plugins/` exists.

Install Yazi (not part of Omarchy):

```bash
sudo pacman -S yazi
```

### 2. Clone

Recommended local layout for this repo family:

```text
~/projects/repos/dotfiles/dotfiles-omarchy
```

Stow can work from any clone location, but the related docs and cross-repo maintenance workflows assume this layout.

```bash
git clone https://github.com/peregrinus879/dotfiles-omarchy.git ~/projects/repos/dotfiles/dotfiles-omarchy
```

### 3. Prepare

Checklist before stowing:

- Omarchy is installed and functional
- `omarchy-nvim` is set up
- Yazi is installed
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
cd ~/projects/repos/dotfiles/dotfiles-omarchy
stow -v -t ~ bash hypr nvim yazi
```

Start a new terminal session, or run `source ~/.bashrc`, for the shell config to take effect.

### Unstow

```bash
cd ~/projects/repos/dotfiles/dotfiles-omarchy
stow -D -v -t ~ bash hypr nvim yazi
```

### Dry Run

Preview what stow would do without making changes:

```bash
cd ~/projects/repos/dotfiles/dotfiles-omarchy
stow -v -n -t ~ bash hypr nvim yazi
```

### Re-stow

To update symlinks after the repo content changes (same clone path):

```bash
cd ~/projects/repos/dotfiles/dotfiles-omarchy
stow -R -v -t ~ bash hypr nvim yazi
```

To migrate from a different clone path, unstow from the old location first:

```bash
cd /old/clone/path
stow -D -v -t ~ bash hypr nvim yazi
cd ~/projects/repos/dotfiles/dotfiles-omarchy
stow -v -t ~ bash hypr nvim yazi
```

If the old clone is no longer available, run the full cleanup in section 3 before stowing.

### Recovery After `omarchy-reinstall-configs`

`omarchy-reinstall-configs` overwrites `~/.bashrc` and `~/.config/` from Omarchy defaults. After running it, re-stow:

```bash
rm -f ~/.bashrc ~/.config/hypr/bindings.conf ~/.config/nvim/lua/plugins/obsidian.lua \
  ~/.config/nvim/lua/plugins/render-markdown.lua ~/.config/yazi/yazi.toml
cd ~/projects/repos/dotfiles/dotfiles-omarchy
stow -R -v -t ~ bash hypr nvim yazi
```

## Verify

After stowing:

- Confirm the core symlinks exist: `test -L ~/.bashrc && test -L ~/.config/hypr/bindings.conf && test -L ~/.config/nvim/lua/plugins/obsidian.lua && test -L ~/.config/yazi/yazi.toml`
- Start a fresh shell and confirm `type cx` shows `claude` without `--allow-dangerously-skip-permissions`.
- Confirm `type tdl` shows the custom 50/50 split and passthrough guard.
- Confirm `type y` shows the Yazi cd-on-exit function.
- Run `nvim` and confirm `:Lazy` shows `obsidian.nvim` and `render-markdown.nvim` loaded.
- Run `yazi` and confirm the layout ratio and sort order match the config.

## References

- `README.md` - package layout, setup, and verification
- `DEVIATIONS.md` - intentional deviations from Omarchy and boundary definitions
- `AGENTS.md` - canonical repo-specific assistant context and maintainer checklist
- `CLAUDE.md` - thin Claude Code wrapper importing `AGENTS.md`

## Related Repos

Clone these locally if you plan to use `/synchronize` or compare against upstream references. The `/synchronize` skill expects reference repos under `~/projects/repos/references/`.

- `~/projects/repos/references/omarchy` - upstream Omarchy reference repo
- `~/projects/repos/references/omarchy-pkgs` - upstream package reference repo

## Credits

Personal customizations on top of [Omarchy](https://github.com/basecamp/omarchy). See [DEVIATIONS.md](DEVIATIONS.md) for intentional differences and boundary definitions.

## License

[MIT](LICENSE)
