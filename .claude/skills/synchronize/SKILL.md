---
name: synchronize
description: Sync personal Omarchy customizations against upstream references and official docs.
---

# Synchronize

Source configs from reference repos and official docs, compare against `dotfiles-omarchy`, and apply changes only where they belong in the personal customizations.

## Sources

### Reference Repos

Reference repos live under `~/projects/repos/references/`:

- `omarchy/` - main repo for bash, tmux, and general Omarchy defaults
### Official Docs

- [The Omarchy Manual](https://learn.omacom.io/2/the-omarchy-manual) - setup guides, keybindings, workflows
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html) - symlink management and package structure
- [Yazi Docs](https://yazi-rs.github.io/docs/) - configuration and themes

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
2. Compare `hypr/bindings.conf` against `omarchy/config/hypr/bindings.conf`:
   - Omarchy default bindings at the top should match upstream
   - Personal bindings at the end are user customizations
3. Compare `yazi/yazi.toml` against official Yazi docs
4. For each difference, classify it:
   - **Intentional personal customization**: documented in `DEVIATIONS.md`, should stay different
   - **New upstream addition**: added upstream after the last sync, should be reviewed for inclusion
   - **Upstream change to existing config**: modified upstream, needs review
5. Check `git log --format="%h %ad %s" --date=short -- <file>` on the relevant reference repo when you need to determine when a difference was introduced
6. Cross-check differences against `DEVIATIONS.md`. If a difference is not documented there, treat it as a likely upstream change that needs review
7. Apply new upstream additions and changes where they belong in the personal customizations
8. Update `README.md`, `AGENTS.md`, and `DEVIATIONS.md` when package ownership, setup steps, or documented deviations change
9. Summarize which changes were adopted, rejected, or intentionally kept different

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
