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

Local clones live side by side under `~/Projects/repos/dotfiles/`.

## Stack

- **Base**: [Omarchy](https://github.com/basecamp/omarchy)
- **Bash**: Personal alias, function, and OpenCode host-environment overrides on top of Omarchy defaults
- **Editor**: [obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) and [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) plugin specs on the `omarchy-nvim` base
- **File Manager**: [Yazi](https://github.com/sxyazi/yazi) (not part of Omarchy)
- **Desktop**: [Hyprland](https://github.com/hyprwm/Hyprland) personal keybindings and display config

## Package Layout

Each top-level directory is a GNU Stow package that symlinks into `$HOME`:

```text
bash/   Bash overrides (.bashrc with Omarchy defaults sourced + personal additions, tdw and hdw workspace functions)
hypr/   Hyprland personal overrides (bindings.lua, monitors.lua, input.lua, looknfeel.lua)
nvim/   Additive Neovim plugin specs for the vault workflow (obsidian.lua, render-markdown.lua)
yazi/   Yazi file manager config (yazi.toml, no theme)
```

Key ownership rules:

- Omarchy manages all defaults, themes, and desktop configs
- `bash/` owns `~/.bashrc`, sources Omarchy defaults, and adds personal overrides below, including the interactive OpenCode skill-isolation and search environment; `dotfiles-ai` owns the OpenCode configuration itself
- `yazi/` is purely additive since Yazi is not part of Omarchy
- `nvim/` is purely additive plugin specs on top of the `omarchy-nvim` base; the vault is expected at `~/Projects/vault` (override with `OBSIDIAN_VAULT`)
- `hypr/` owns `~/.config/hypr/bindings.lua`, `~/.config/hypr/monitors.lua`, `~/.config/hypr/input.lua`, and `~/.config/hypr/looknfeel.lua`: personal overrides only, loaded after the Omarchy defaults; all other Hyprland config is Omarchy-owned and untracked
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

Remove existing files that would conflict with stow. The guarded preparation script removes only symlinks that resolve into this repo (tree-folded directory links first, so per-file removals never resolve through a fold into the repo) and regular files at owned paths (Omarchy clobber artifacts); anything unrecognized aborts the run untouched:

```bash
cd ~/Projects/repos/dotfiles/dotfiles-omarchy
make clean
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

### Recovery After Omarchy Config Resets

`omarchy-reinstall-configs` overwrites `~/.bashrc` and `~/.config/` from Omarchy defaults (on quattro via `cp -af /etc/skel/. ~/`). After running it, `git restore` any repo files it clobbered through stow symlinks, then run `make recover` from the repo root (the Prepare cleanup plus a re-stow).

`omarchy-refresh-hyprland` (and `omarchy-refresh-config` generally) copies shipped defaults over existing files with `cp -f`, which writes through a stow symlink into the repo working tree; the symlink itself survives and a timestamped `.bak` of the personal content is left beside it. After it runs, `git restore hypr/.config/hypr/` is the whole recovery.

## Verify

After stowing or changing owned packages:

- Run `make verify` and `make lint` from the repo root (`verify` compares resolved paths, so stow tree-folding does not false-negative).
- Start a fresh shell and confirm `printenv OPENCODE_DISABLE_EXTERNAL_SKILLS` and `printenv OPENCODE_ENABLE_EXA` each print `1`; non-interactive OpenCode launchers must supply both variables themselves.
- Start a fresh shell and confirm `type y` shows the Yazi cd-on-exit function.
- Confirm `type tdw` shows the tmux workspace function; from a project directory, `tdw cc` or `tdw oc` opens its session (`-c` continues that agent's last conversation; bare `tdw` re-attaches an existing session).
- Confirm `type hdw` shows the herdr workspace function; from a project directory, `hdw cc` or `hdw oc` opens its workspace (bare `hdw` refocuses; the herdr server is started headless when down, and if that start fails `hdw` attaches plain herdr, rerun it inside).
- Run `yazi` and confirm the layout ratio and sort order match the config.
- Open a vault note in Neovim and confirm obsidian.nvim loads (`<leader>oo` opens the note switcher).

## Maintenance

A repo-root `Makefile` keeps the package list in one place and wraps the routine commands. Run targets from the repo root on the Omarchy machine:

- `make stow` / `make unstow` / `make dry-run` / `make restow` - the stow command sets from Setup
- `make verify` - the Verify symlink checks, bash and Lua syntax, TOML validity, and the twin-file sync check against `dotfiles-wsl`
- `make clean` - guarded stow preparation (`scripts/prepare-stow.sh`); owned links and clobber artifacts only, aborts on anything unrecognized
- `make recover` - the Recovery steps after `omarchy-reinstall-configs` (clean + restow)
- `make lint` - ShellCheck over the bash package and `scripts/`; `.shellcheckrc` disables the upstream-derived warnings so new issues stand out

`make stow`, `make restow`, and `make recover` finish with a forced Hyprland reload and config-error check when run inside a Hyprland session (rationale in the Makefile header); `make verify` runs the same check read-only.

Periodically, review the local reference repos and official docs for upstream changes to overridden items, sync with `/omasync` or a manual comparison, and confirm every intentional difference is still documented in `DEVIATIONS.md`. Durable findings, known limitations, and deferred items live in [docs/maintenance.md](docs/maintenance.md).

## Related Repos

Upstream comparison runs through the `/omasync` skill, which carries the local reference clone paths. Upstream URLs and official docs live in [DEVIATIONS.md](DEVIATIONS.md) (Reference Sources).

## Credits

Personal customizations on top of [Omarchy](https://github.com/basecamp/omarchy). See [DEVIATIONS.md](DEVIATIONS.md) for intentional differences and boundary definitions.

## License

[MIT](LICENSE)
