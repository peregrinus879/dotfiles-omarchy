# Maintenance Ledger - dotfiles-omarchy

Read this file before package removals, Omarchy updates or refreshes, work on a deferred item, or cross-repo coordination. Current operational policy stays in `AGENTS.md`; this ledger carries dated findings, known limitations, and deferred items. It records repo decisions and behavior official docs do not state; doc-derivable facts (defaults, version gates, upstream status) are fetched at change time, not cached here.

## Known Limitations

- `omarchy-reinstall-configs` (on quattro via `cp -af /etc/skel/. ~/`) and `omarchy-refresh-config` copy defaults with no symlink awareness, writing through stow symlinks into this repo's files; if either runs, `git restore` the clobbered repo files first, then run `make recover`.
- `omarchy-refresh-hyprland` refreshes every `~/.config/hypr` Lua file including the stowed `bindings.lua`; the `cp -f` writes the shipped default through the symlink into the repo working tree (the link survives, a timestamped `.bak` of the personal content is left beside it). Recovery is `git restore hypr/.config/hypr/bindings.lua`. Verified against the installed 4.0.0 scripts on 2026-08-15.
- Stow tree-folds `~/.config/yazi` into a directory symlink pointing at the repo, so anything written there lands in the repo working tree; folding is the accepted repo-family stow convention (do not add `--no-folding`).
- `qt6-wayland` reads as a pacman orphan but carries Quickshell and every Qt6 app at runtime (platform plugins load without a pacman dependency edge) and is marked explicit. Never remove `pacman -Qdtq` output as a batch on this machine.

## Deferred Items

- resync `dotfiles-wsl` to the Omarchy 4.0 baseline on the WSL host: its `AGENTS.md` Deferred Items are self-contained (consolidation commit 9361386: inlined drift list, omasync mirror-rename, dotfiles-ai host-pass pointer); the laptop-local scratch runbook is fully superseded and can be archived.
- dotfiles-ai post-quattro absorption session: record diagnose-crash ownership (see the migration item below); re-check the spar bridges' 30-second preflights against cold mise-wrapper first-call installs; add the effort-pin cross-reference (this repo's interactive `claude --effort ultracode` alias overrides its tracked `effortLevel xhigh` pin).
- upstream `tdl` ends with `select-pane -t "$opencode_pane"` on a variable it never sets, verified at v4.0.0 `default/bash/fns/tmux` on 2026-08-15 (cosmetic focus regression; `post-4.0-fixes` does not touch it).
- close or rework basecamp/omarchy#5256 (the `tdl` passthrough-guard PR from this account); no local guard is tracked (the guard approach is ineffective).
- watch the tree-folded `~/.config/yazi`: the first `ya pkg` install writes `plugins/` and `package.toml` into the repo working tree; decide then whether to track them (the `dotfiles-ai` opencode-deps pattern) or gitignore them (the `dotfiles-wsl` git-identity pattern).
- watch `~/.local/bin` on quattro: every `omarchy-refresh-applications` runs `rm -f` on the 13 managed CLI names (claude, codex, opencode, crush, gemini, gh, copilot, playwright, pi, omp, grok, ghui, hunk) and rewrites them as lazy mise wrappers. The `dotfiles-ai` spar bins (`spar-claude`, `spar-codex`, `spar-payload-scan`) are not in the list and survive.
- quattro migrations and agent skills: migration 1786539345 symlinks `diagnose-crash` into four dirs (`~/.agents/skills`, `~/.claude/skills`, `~/.codex/skills`, `~/.pi/agent/skills`) and enables `omarchy-crash-watch.service`; migration 1786098807 relinks the `omarchy` skill into the same four. No stow collision (`dotfiles-ai` keeps those parents as real directories); OpenCode cannot see diagnose-crash by design (its `skills.paths` restores only the omarchy skill). The ownership decision belongs to `dotfiles-ai`.
- `~/.local/bin/playwright-cli` is an orphan owned by neither repo (npx-style wrapper), redundant with quattro's mise `playwright` wrapper; delete or adopt (H's call).
- later iteration: `tests/` fixtures and executable config contracts in the `dotfiles-ai` style (TOML validity for `yazi.toml`, `hl.unbind` chords asserted against current defaults, fake-home clean/restow fixtures).
